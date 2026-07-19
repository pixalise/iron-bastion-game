class_name GameUiTheme
extends RefCounted

const CARD_BACKGROUND := Color(0.08, 0.075, 0.065, 0.94)
const CARD_BORDER := Color(0.55, 0.46, 0.31, 0.95)
const CARD_TEXT := Color(0.93, 0.88, 0.75, 1.0)
const CARD_MUTED_TEXT := Color(0.86, 0.84, 0.78, 1.0)
const CARD_PLACEHOLDER_TEXT := Color(0.84, 0.78, 0.65, 0.85)
const PORTRAIT_BACKGROUND := Color(0.12, 0.115, 0.1, 1.0)
const PORTRAIT_BORDER := Color(0.42, 0.34, 0.22, 1.0)

const TOOLTIP_WIDTH := 280.0
const TOOLTIP_PADDING := 4
const TOOLTIP_GAP := 4
const TOOLTIP_TITLE_GAP := 6
const TOOLTIP_ICON_SIZE := Vector2(18.0, 18.0)
const TOOLTIP_TITLE_FONT_SIZE := 13
const TOOLTIP_BODY_FONT_SIZE := 12
const TOOLTIP_BACKGROUND := Color(0.08, 0.075, 0.065, 1.0)
const TOOLTIP_BORDER := Color(0.55, 0.46, 0.31, 1.0)
const TOOLTIP_TITLE_TEXT := Color(0.98, 0.9, 0.7, 1.0)
const TOOLTIP_BODY_TEXT := Color(0.9, 0.88, 0.8, 1.0)


static func panel_style(
	background: Color, border: Color, border_width: int = 1, radius: int = 2
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
	return style


static func set_margin(margin: MarginContainer, value: int) -> void:
	margin.add_theme_constant_override("margin_left", value)
	margin.add_theme_constant_override("margin_top", value)
	margin.add_theme_constant_override("margin_right", value)
	margin.add_theme_constant_override("margin_bottom", value)


static func set_rich_text_font_size(label: RichTextLabel, font_size: int) -> void:
	label.add_theme_font_size_override("normal_font_size", font_size)
	label.add_theme_font_size_override("bold_font_size", font_size)
	label.add_theme_font_size_override("italics_font_size", font_size)
	label.add_theme_font_size_override("bold_italics_font_size", font_size)


static func tooltip_popup_theme() -> Theme:
	var next_theme := Theme.new()
	next_theme.set_stylebox("panel", "TooltipPanel", StyleBoxEmpty.new())
	return next_theme
