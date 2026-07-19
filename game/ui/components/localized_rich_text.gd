class_name LocalizedRichText
extends RichTextLabel

const DEFAULT_INLINE_ICON_SIZE := Vector2i(16, 16)
const TOOLTIP_WIDTH := 280.0
const UNDERLINE_Y_OFFSET := 1.0
const FONT_THEME_KEYS := [
	{"font": "normal_font", "size": "normal_font_size"},
	{"font": "bold_font", "size": "bold_font_size"},
	{"font": "italics_font", "size": "italics_font_size"},
	{"font": "bold_italics_font", "size": "bold_italics_font_size"}
]

var inline_icon_size := DEFAULT_INLINE_ICON_SIZE

var _tooltip_text_by_slug: Dictionary = {}
var _tooltip_bbcode_by_slug: Dictionary = {}


func _init() -> void:
	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	hint_underlined = false


func _ready() -> void:
	_apply_underline_offset(self)


func set_localized_text(value: ChiselLocalization.LocalizedText) -> void:
	_tooltip_text_by_slug.clear()
	_tooltip_bbcode_by_slug.clear()

	if value == null:
		text = ""
		tooltip_text = ""
		return

	text = _build_bbcode(value)
	tooltip_text = ""


func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip_text_value := String(_tooltip_text_by_slug.get(for_text, for_text))
	var tooltip_bbcode := String(
		_tooltip_bbcode_by_slug.get(for_text, _bbcode_escape(tooltip_text_value))
	)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(TOOLTIP_WIDTH, 0.0)
	panel.add_theme_stylebox_override("panel", _tooltip_panel_style())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.scroll_active = false
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(TOOLTIP_WIDTH - 16.0, 0.0)
	label.text = tooltip_bbcode
	label.add_theme_font_size_override("normal_font_size", 12)
	label.add_theme_font_size_override("bold_font_size", 12)
	label.add_theme_font_size_override("italics_font_size", 12)
	label.add_theme_font_size_override("bold_italics_font_size", 12)
	label.add_theme_color_override("default_color", Color(0.9, 0.88, 0.8, 1.0))
	_apply_underline_offset(label)
	margin.add_child(label)

	return panel


func _build_bbcode(value: ChiselLocalization.LocalizedText) -> String:
	if value.spans.is_empty():
		return _size_existing_images(value.bbcode_text)

	var plain := value.plain_text
	var open_events := {}
	var close_events := {}
	var icons_by_start := {}

	for span in value.spans:
		var span_type := String(span.get("type", ""))
		var start := _clamped_index(span.get("start", 0), plain.length())
		var end := _clamped_index(span.get("end", start), plain.length())
		if end < start:
			continue

		if span_type == "icon":
			icons_by_start[start] = span
		elif span_type == "style":
			_add_span_events(open_events, close_events, start, end, span)
		elif span_type == "tooltip":
			_add_tooltip_events(open_events, close_events, start, end, span)

	var output := ""
	var index := 0
	while index <= plain.length():
		output += _render_events(close_events.get(index, []))
		output += _render_events(open_events.get(index, []))
		if index == plain.length():
			break

		var icon: Dictionary = icons_by_start.get(index, {})
		if not icon.is_empty():
			output += _icon_bbcode(icon)
			index = max(index + 1, _clamped_index(icon.get("end", index + 1), plain.length()))
		else:
			output += _bbcode_escape(plain.substr(index, 1))
			index += 1

	return output


func _add_span_events(
	open_events: Dictionary, close_events: Dictionary, start: int, end: int, span: Dictionary
) -> void:
	var open_tags := _style_open_tags(span)
	if open_tags.is_empty():
		return

	_add_event(
		open_events, start, {"type": "style", "start": start, "end": end, "tags": open_tags}, true
	)
	_add_event(
		close_events,
		end,
		{"type": "style", "start": start, "end": end, "tags": _style_close_tags(span)},
		false
	)


func _add_tooltip_events(
	open_events: Dictionary, close_events: Dictionary, start: int, end: int, span: Dictionary
) -> void:
	var tooltip_slug := String(span.get("tooltip", ""))
	if tooltip_slug.is_empty():
		return

	var tooltip_text_value := String(span.get("tooltip_text", ""))
	_tooltip_text_by_slug[tooltip_slug] = tooltip_text_value
	_tooltip_bbcode_by_slug[tooltip_slug] = _size_existing_images(
		String(span.get("tooltip_bbcode_text", _bbcode_escape(tooltip_text_value)))
	)

	_add_event(
		open_events,
		start,
		{"type": "tooltip", "start": start, "end": end, "tags": ["[hint=%s]" % tooltip_slug]},
		true
	)
	_add_event(
		close_events,
		end,
		{"type": "tooltip", "start": start, "end": end, "tags": ["[/hint]"]},
		false
	)


func _add_event(events_by_index: Dictionary, index: int, event: Dictionary, opening: bool) -> void:
	var events: Array = events_by_index.get(index, [])
	var insert_at := events.size()

	for event_index in range(events.size()):
		if _event_before(event, events[event_index], opening):
			insert_at = event_index
			break

	events.insert(insert_at, event)
	events_by_index[index] = events


func _event_before(event: Dictionary, existing: Dictionary, opening: bool) -> bool:
	if opening:
		var end := int(event.get("end", 0))
		var existing_end := int(existing.get("end", 0))
		if end != existing_end:
			return end > existing_end
		return _event_priority(event) < _event_priority(existing)

	var start := int(event.get("start", 0))
	var existing_start := int(existing.get("start", 0))
	if start != existing_start:
		return start > existing_start
	return _event_priority(event) > _event_priority(existing)


func _event_priority(event: Dictionary) -> int:
	var event_type := String(event.get("type", ""))
	if event_type == "style":
		return 0
	if event_type == "tooltip":
		return 1
	return 2


func _render_events(events: Array) -> String:
	var output := ""
	for event in events:
		var tags: Array = event.get("tags", [])
		for tag in tags:
			output += String(tag)
	return output


func _style_open_tags(span: Dictionary) -> Array:
	var tags := []
	var color := String(span.get("color", ""))
	if not color.is_empty():
		tags.append("[color=%s]" % color)
	if bool(span.get("bold", false)):
		tags.append("[b]")
	if bool(span.get("italic", false)):
		tags.append("[i]")
	if bool(span.get("underline", false)):
		tags.append("[u]")
	return tags


func _style_close_tags(span: Dictionary) -> Array:
	var tags := []
	if bool(span.get("underline", false)):
		tags.append("[/u]")
	if bool(span.get("italic", false)):
		tags.append("[/i]")
	if bool(span.get("bold", false)):
		tags.append("[/b]")
	if not String(span.get("color", "")).is_empty():
		tags.append("[/color]")
	return tags


func _apply_underline_offset(label: RichTextLabel) -> void:
	for keys in FONT_THEME_KEYS:
		var font_key := String(keys.get("font", ""))
		var size_key := String(keys.get("size", ""))
		var font := label.get_theme_font(font_key)
		var font_size := label.get_theme_font_size(size_key)
		var adjusted_font := _font_with_underline_offset(font, font_size)
		if adjusted_font != null:
			label.add_theme_font_override(font_key, adjusted_font)


func _font_with_underline_offset(font: Font, font_size: int) -> Font:
	if font is FontFile:
		var font_file := font.duplicate(true) as FontFile
		_offset_font_file_underline(font_file, font_size)
		return font_file

	if font is FontVariation:
		var variation := font.duplicate(true) as FontVariation
		var base_font := variation.get_base_font()
		if base_font is FontFile:
			var base_font_file := base_font.duplicate(true) as FontFile
			_offset_font_file_underline(base_font_file, font_size)
			variation.set_base_font(base_font_file)
		return variation

	return font


func _offset_font_file_underline(font_file: FontFile, font_size: int) -> void:
	var current_position := font_file.get_underline_position(font_size)
	font_file.set_cache_underline_position(0, font_size, current_position + UNDERLINE_Y_OFFSET)


func _icon_bbcode(span: Dictionary) -> String:
	var path := String(span.get("path", ""))
	if path.is_empty():
		return _bbcode_escape("[%s]" % String(span.get("icon", "ICON")))

	return "[img=%dx%d]%s[/img]" % [inline_icon_size.x, inline_icon_size.y, _bbcode_escape(path)]


func _size_existing_images(value: String) -> String:
	return value.replace("[img]", "[img=%dx%d]" % [inline_icon_size.x, inline_icon_size.y])


func _bbcode_escape(value: String) -> String:
	return value.replace("[", "\\[").replace("]", "\\]")


func _clamped_index(value: Variant, maximum: int) -> int:
	return max(0, min(int(value), maximum))


func _tooltip_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.075, 0.065, 0.96)
	style.border_color = Color(0.55, 0.46, 0.31, 0.95)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_right = 2
	style.corner_radius_bottom_left = 2
	return style
