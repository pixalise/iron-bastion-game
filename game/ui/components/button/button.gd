@tool
class_name GameButton
extends Button

const UI_THEME := preload("res://game/ui/ui_theme.gd")

var _is_applying_theme := false

@export var button_variant: GameUiTheme.ButtonVariant = GameUiTheme.ButtonVariant.DEFAULT:
	set(value):
		if button_variant == value:
			return
		button_variant = value
		_apply_theme()

@export var button_size: GameUiTheme.ButtonSize = GameUiTheme.ButtonSize.DEFAULT:
	set(value):
		if button_size == value:
			return
		button_size = value
		_apply_theme()


func _ready() -> void:
	_apply_theme()


func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED and not _is_applying_theme:
		_apply_theme()


func _apply_theme() -> void:
	if _is_applying_theme:
		return

	_is_applying_theme = true
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = CURSOR_POINTING_HAND
	add_theme_font_size_override("font_size", UI_THEME.button_font_size(button_size))
	add_theme_color_override("font_color", UI_THEME.button_font_color(button_variant))
	add_theme_color_override("font_hover_color", UI_THEME.button_font_color(button_variant))
	add_theme_color_override("font_pressed_color", UI_THEME.button_font_color(button_variant))
	add_theme_color_override("font_focus_color", UI_THEME.button_font_color(button_variant))
	add_theme_color_override("font_hover_pressed_color", UI_THEME.button_font_color(button_variant))
	add_theme_color_override("font_disabled_color", UI_THEME.button_font_color(button_variant, true))
	add_theme_stylebox_override("normal", UI_THEME.button_stylebox(button_variant, button_size))
	add_theme_stylebox_override("hover", UI_THEME.button_stylebox(button_variant, button_size, true))
	add_theme_stylebox_override("pressed", UI_THEME.button_stylebox(button_variant, button_size, false, true))
	add_theme_stylebox_override("focus", UI_THEME.button_stylebox(button_variant, button_size, false, false, false, true))
	add_theme_stylebox_override("disabled", UI_THEME.button_stylebox(button_variant, button_size, false, false, true))

	var width := custom_minimum_size.x
	custom_minimum_size = Vector2(width, UI_THEME.button_minimum_height(button_size))
	_is_applying_theme = false
