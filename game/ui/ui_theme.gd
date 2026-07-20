class_name GameUiTheme
extends RefCounted

enum ButtonVariant { DEFAULT, SECONDARY, OUTLINE, GHOST }
enum ButtonSize { SM, DEFAULT, LG }

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
const TEXT_LG := 16


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


static func button_font_size(size: ButtonSize) -> int:
	match size:
		ButtonSize.SM:
			return TEXT_SM
		ButtonSize.LG:
			return TEXT_LG
		_:
			return TEXT_BASE


static func button_minimum_height(size: ButtonSize) -> int:
	match size:
		ButtonSize.SM:
			return 34
		ButtonSize.LG:
			return 48
		_:
			return 40


static func button_stylebox(
	variant: ButtonVariant, size: ButtonSize = ButtonSize.DEFAULT, hovered: bool = false,
	pressed: bool = false,
	disabled: bool = false, focused: bool = false
) -> StyleBoxFlat:
	var background := _button_background_color(variant, hovered, pressed, disabled)
	var border := _button_border_color(variant, hovered, pressed, disabled)
	var border_width := 1
	if variant == ButtonVariant.GHOST and not hovered and not pressed and not disabled:
		border_width = 0
	if focused:
		border = RING
		border_width = max(border_width, 2)

	var style := panel_style(background, border, border_width, RADIUS_MD)
	var horizontal_padding := _button_horizontal_padding(size)
	style.content_margin_left = horizontal_padding
	style.content_margin_right = horizontal_padding
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style


static func button_font_color(variant: ButtonVariant, disabled: bool = false) -> Color:
	if disabled:
		return MUTED_FOREGROUND

	match variant:
		ButtonVariant.DEFAULT:
			return PRIMARY_FOREGROUND
		ButtonVariant.SECONDARY:
			return SECONDARY_FOREGROUND
		_:
			return FOREGROUND


static func tooltip_popup_theme() -> Theme:
	var next_theme := Theme.new()
	next_theme.set_stylebox("panel", "TooltipPanel", StyleBoxEmpty.new())
	return next_theme


static func _button_background_color(
	variant: ButtonVariant, hovered: bool, pressed: bool, disabled: bool
) -> Color:
	if disabled:
		return _with_alpha(MUTED, 0.4)

	match variant:
		ButtonVariant.DEFAULT:
			if pressed:
				return PRIMARY.lerp(BACKGROUND, 0.24)
			if hovered:
				return PRIMARY.lerp(FOREGROUND, 0.08)
			return PRIMARY
		ButtonVariant.SECONDARY:
			if pressed:
				return ACCENT.lerp(BACKGROUND, 0.18)
			if hovered:
				return SECONDARY.lerp(FOREGROUND, 0.06)
			return SECONDARY
		ButtonVariant.OUTLINE:
			if pressed:
				return _with_alpha(ACCENT, 0.52)
			if hovered:
				return _with_alpha(ACCENT, 0.34)
			return _with_alpha(CARD, 0.14)
		ButtonVariant.GHOST:
			if pressed:
				return _with_alpha(MUTED, 0.74)
			if hovered:
				return _with_alpha(MUTED, 0.46)
			return Color(0, 0, 0, 0)
		_:
			return PRIMARY


static func _button_border_color(
	variant: ButtonVariant, hovered: bool, pressed: bool, disabled: bool
) -> Color:
	if disabled:
		return _with_alpha(BORDER, 0.45)

	match variant:
		ButtonVariant.DEFAULT:
			if pressed:
				return PRIMARY.lerp(BACKGROUND, 0.4)
			if hovered:
				return PRIMARY.lerp(FOREGROUND, 0.16)
			return PRIMARY
		ButtonVariant.SECONDARY:
			if pressed:
				return ACCENT
			if hovered:
				return BORDER.lerp(FOREGROUND, 0.08)
			return BORDER
		ButtonVariant.OUTLINE:
			if hovered or pressed:
				return PRIMARY
			return BORDER
		ButtonVariant.GHOST:
			if hovered or pressed:
				return _with_alpha(BORDER, 0.6)
			return Color(0, 0, 0, 0)
		_:
			return BORDER


static func _button_horizontal_padding(size: ButtonSize) -> int:
	match size:
		ButtonSize.SM:
			return 12
		ButtonSize.LG:
			return 22
		_:
			return 16


static func _with_alpha(color: Color, alpha: float) -> Color:
	return Color(color.r, color.g, color.b, alpha)
