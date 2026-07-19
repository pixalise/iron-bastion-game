class_name LocalizedRichText
extends RichTextLabel

const TOOLTIP_WIDTH := 280.0
const UNDERLINE_Y_OFFSET := 1.0
const FONT_THEME_KEYS := [
	{"font": "normal_font", "size": "normal_font_size"},
	{"font": "bold_font", "size": "bold_font_size"},
	{"font": "italics_font", "size": "italics_font_size"},
	{"font": "bold_italics_font", "size": "bold_italics_font_size"}
]

var _tooltip_content_by_slug: Dictionary = {}


func _init() -> void:
	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	hint_underlined = false


func _ready() -> void:
	_apply_underline_offset(self)


func set_localized_text(value: ChiselLocalization.LocalizedText) -> void:
	_tooltip_content_by_slug.clear()

	if value == null:
		text = ""
		tooltip_text = ""
		return

	_register_tooltips(value)
	text = value.bbcode_text
	tooltip_text = ""


func _make_custom_tooltip(for_text: String) -> Object:
	var content: Variant = _tooltip_content_by_slug.get(for_text, null)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(TOOLTIP_WIDTH, 0.0)
	panel.add_theme_stylebox_override("panel", _tooltip_panel_style())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var content_box := VBoxContainer.new()
	content_box.add_theme_constant_override("separation", 5)
	margin.add_child(content_box)

	if content == null:
		content_box.add_child(_fallback_label(_bbcode_escape(for_text), TOOLTIP_WIDTH - 16.0))
		return panel

	var icon_path := String(content.icon_path)
	var title_text: ChiselLocalization.LocalizedText = content.title
	if not icon_path.is_empty() or not title_text.plain_text.is_empty():
		var title_row := HBoxContainer.new()
		title_row.add_theme_constant_override("separation", 6)
		content_box.add_child(title_row)

		if not icon_path.is_empty():
			var icon := TextureRect.new()
			icon.custom_minimum_size = Vector2(18.0, 18.0)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.texture = load(icon_path) as Texture2D
			title_row.add_child(icon)

		if not title_text.plain_text.is_empty():
			var title_label := _localized_label(title_text, TOOLTIP_WIDTH - 40.0, 13)
			title_label.add_theme_color_override("default_color", Color(0.98, 0.9, 0.7, 1.0))
			title_row.add_child(title_label)

	var description_text: ChiselLocalization.LocalizedText = content.description
	if not description_text.plain_text.is_empty():
		var description_label := _localized_label(description_text, TOOLTIP_WIDTH - 16.0, 12)
		description_label.add_theme_color_override("default_color", Color(0.9, 0.88, 0.8, 1.0))
		content_box.add_child(description_label)

	return panel


func _register_tooltips(value: ChiselLocalization.LocalizedText) -> void:
	for span in value.spans:
		if String(span.get("type", "")) != "tooltip":
			continue
		var tooltip_slug := String(span.get("tooltip", ""))
		if tooltip_slug.is_empty():
			continue
		_tooltip_content_by_slug[tooltip_slug] = value.tooltip_content_for(StringName(tooltip_slug))


func _localized_label(
	value: ChiselLocalization.LocalizedText, minimum_width: float, font_size: int
) -> LocalizedRichText:
	var label := LocalizedRichText.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(minimum_width, 0.0)
	label.add_theme_font_size_override("normal_font_size", font_size)
	label.add_theme_font_size_override("bold_font_size", font_size)
	label.add_theme_font_size_override("italics_font_size", font_size)
	label.add_theme_font_size_override("bold_italics_font_size", font_size)
	label.set_localized_text(value)
	return label


func _fallback_label(bbcode: String, minimum_width: float) -> RichTextLabel:
	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.scroll_active = false
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(minimum_width, 0.0)
	label.text = bbcode
	label.add_theme_font_size_override("normal_font_size", 12)
	label.add_theme_font_size_override("bold_font_size", 12)
	label.add_theme_font_size_override("italics_font_size", 12)
	label.add_theme_font_size_override("bold_italics_font_size", 12)
	label.add_theme_color_override("default_color", Color(0.9, 0.88, 0.8, 1.0))
	_apply_underline_offset(label)
	return label


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


func _bbcode_escape(value: String) -> String:
	return value.replace("[", "\\[").replace("]", "\\]")


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
