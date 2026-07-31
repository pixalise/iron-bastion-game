class_name LocalizedRichText
extends RichTextLabel

const UI_THEME := preload("res://game/ui/theme/ui_theme.gd")
const LOCALIZED_TOOLTIP := preload("res://game/ui/components/localized_tooltip.gd")
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
	theme = UI_THEME.tooltip_popup_theme()


func _ready() -> void:
	_apply_underline_offset(self)


func set_localized_text(value: ChiselLocalization.LocalizedText) -> void:
	_tooltip_content_by_slug.clear()
	_register_tooltips(value)
	text = value.bbcode_text
	tooltip_text = ""


func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip := LOCALIZED_TOOLTIP.new()
	tooltip.set_tooltip_content(_tooltip_content_by_slug[for_text])
	return tooltip


func _register_tooltips(value: ChiselLocalization.LocalizedText) -> void:
	for span in value.spans:
		if String(span.get("type", "")) != "tooltip":
			continue
		var tooltip_slug := String(span.get("tooltip", ""))
		if tooltip_slug.is_empty():
			continue
		_tooltip_content_by_slug[tooltip_slug] = value.tooltip_content_for(StringName(tooltip_slug))


func _apply_underline_offset(label: RichTextLabel) -> void:
	for keys in FONT_THEME_KEYS:
		var font_key := String(keys.get("font", ""))
		var size_key := String(keys.get("size", ""))
		var font := label.get_theme_font(font_key)
		var font_size := label.get_theme_font_size(size_key)
		var adjusted_font := _font_with_underline_offset(font, font_size)
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
