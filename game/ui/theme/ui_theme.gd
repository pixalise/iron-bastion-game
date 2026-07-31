class_name GameUiTheme
extends RefCounted

enum ButtonVariant { DEFAULT, SECONDARY, OUTLINE, GHOST }
enum ButtonSize { SM, DEFAULT, LG }

const VOID := Color(0.07843137, 0.08235294, 0.09019608, 1.0)
const CHARCOAL := Color(0.10980392, 0.10980392, 0.11372549, 1.0)
const STONE_SHADOW := Color(0.16862745, 0.15686275, 0.15294118, 1.0)
const STONE_MID := Color(0.29803922, 0.27058824, 0.24313725, 1.0)
const WARM_TAUPE := Color(0.50980392, 0.44705882, 0.38823529, 1.0)
const PARCHMENT := Color(0.65490196, 0.57254902, 0.49411765, 1.0)
const CANDLE_GLOW := Color(0.76078431, 0.66666667, 0.58431373, 1.0)
const BLOOD_SHADOW := Color(0.35294118, 0.17647059, 0.15686275, 1.0)
const RITUAL_RED := Color(0.72941176, 0.34117647, 0.28235294, 1.0)

const BACKGROUND := VOID
const FOREGROUND := PARCHMENT
const CARD := CHARCOAL
const CARD_FOREGROUND := PARCHMENT
const PRIMARY := RITUAL_RED
const PRIMARY_FOREGROUND := VOID
const SECONDARY := STONE_SHADOW
const SECONDARY_FOREGROUND := PARCHMENT
const MUTED := STONE_SHADOW
const MUTED_FOREGROUND := WARM_TAUPE
const ACCENT := BLOOD_SHADOW
const ACCENT_FOREGROUND := CANDLE_GLOW
const BORDER := STONE_MID
const RING := RITUAL_RED

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


static func card_panel_style(padding: int = 0) -> StyleBoxFlat:
	var style := panel_style(CARD, BORDER, 1, RADIUS_MD)
	if padding > 0:
		style.content_margin_left = padding
		style.content_margin_top = padding
		style.content_margin_right = padding
		style.content_margin_bottom = padding
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
