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

	_register_tooltips(value)
	text = value.bbcode_text
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


func _register_tooltips(value: ChiselLocalization.LocalizedText) -> void:
	for span in value.spans:
		if String(span.get("type", "")) != "tooltip":
			continue
		var tooltip_slug := String(span.get("tooltip", ""))
		if tooltip_slug.is_empty():
			continue
		var tooltip_text_value := String(span.get("tooltip_text", ""))
		_tooltip_text_by_slug[tooltip_slug] = tooltip_text_value
		_tooltip_bbcode_by_slug[tooltip_slug] = String(
			span.get("tooltip_bbcode_text", _bbcode_escape(tooltip_text_value))
		)


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
