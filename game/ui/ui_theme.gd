class_name GameUiTheme
extends RefCounted

const BACKGROUND := Color(0.08, 0.075, 0.065, 1.0)
const FOREGROUND := Color(0.93, 0.88, 0.75, 1.0)
const CARD := Color(0.08, 0.075, 0.065, 0.94)
const CARD_FOREGROUND := FOREGROUND
const POPOVER := BACKGROUND
const POPOVER_FOREGROUND := Color(0.9, 0.88, 0.8, 1.0)
const PRIMARY := Color(0.7, 0.56, 0.32, 1.0)
const PRIMARY_FOREGROUND := Color(0.08, 0.075, 0.065, 1.0)
const SECONDARY := Color(0.12, 0.115, 0.1, 1.0)
const SECONDARY_FOREGROUND := FOREGROUND
const MUTED := Color(0.12, 0.115, 0.1, 1.0)
const MUTED_FOREGROUND := Color(0.84, 0.78, 0.65, 0.85)
const ACCENT := Color(0.42, 0.34, 0.22, 1.0)
const ACCENT_FOREGROUND := FOREGROUND
const BORDER := Color(0.55, 0.46, 0.31, 1.0)
const RING := PRIMARY

const RADIUS_SM := 2
const RADIUS_MD := 4

const SPACE_1 := 4
const SPACE_2 := 8

const TEXT_XS := 12
const TEXT_SM := 13
const TEXT_BASE := 14


static func panel_style(
	background: Color = CARD, border: Color = BORDER, border_width: int = 1, radius: int = RADIUS_SM
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
