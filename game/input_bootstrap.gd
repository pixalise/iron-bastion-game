extends Node

const CHISEL_INPUT_EXPORT_PATH := "res://game_data/input.gd"
const ACTIONS := preload("res://game/input_actions.gd")


func _ready() -> void:
	if _apply_chisel_input_map():
		return

	_apply_fallback_input_map()


func _apply_chisel_input_map() -> bool:
	if not ResourceLoader.exists(CHISEL_INPUT_EXPORT_PATH):
		return false

	var input_script := load(CHISEL_INPUT_EXPORT_PATH)
	if input_script == null:
		push_warning("Failed to load Chisel input export: %s" % CHISEL_INPUT_EXPORT_PATH)
		return false

	var input_export = input_script.new()
	if not input_export.has_method("apply_to_input_map"):
		push_warning("Chisel input export does not expose apply_to_input_map().")
		return false

	input_export.apply_to_input_map()
	return true


func _apply_fallback_input_map() -> void:
	_bind_key(ACTIONS.MOVE_LEFT, KEY_A)
	_bind_key(ACTIONS.MOVE_RIGHT, KEY_D)
	_bind_key(ACTIONS.MOVE_FORWARD, KEY_W)
	_bind_key(ACTIONS.MOVE_BACKWARD, KEY_S)
	_bind_key(ACTIONS.MOVE_UP, KEY_E)
	_bind_key(ACTIONS.MOVE_UP, KEY_SPACE, false)
	_bind_key(ACTIONS.MOVE_DOWN, KEY_Q)
	_bind_key(ACTIONS.MOVE_FAST, KEY_SHIFT)
	_bind_key(ACTIONS.INCREASE_MOVE_SPEED, KEY_KP_ADD)
	_bind_key(ACTIONS.INCREASE_MOVE_SPEED, KEY_EQUAL, false)
	_bind_mouse(ACTIONS.INCREASE_MOVE_SPEED, MOUSE_BUTTON_WHEEL_UP, false)
	_bind_key(ACTIONS.DECREASE_MOVE_SPEED, KEY_KP_SUBTRACT)
	_bind_key(ACTIONS.DECREASE_MOVE_SPEED, KEY_MINUS, false)
	_bind_mouse(ACTIONS.DECREASE_MOVE_SPEED, MOUSE_BUTTON_WHEEL_DOWN, false)
	_bind_key(ACTIONS.TOGGLE_CAMERA_VIEW, KEY_V)
	_bind_key(ACTIONS.TOGGLE_GRAVITY, KEY_G)
	_bind_key(ACTIONS.TOGGLE_COLLISION, KEY_C)
	_bind_key(ACTIONS.QUIT_DEMO, KEY_F8)
	_bind_key(ACTIONS.TOGGLE_UI, KEY_F9)
	_bind_key(ACTIONS.CYCLE_RENDER_MODE, KEY_F10)
	_bind_key(ACTIONS.TOGGLE_FULLSCREEN, KEY_F11)
	_bind_key(ACTIONS.TOGGLE_MOUSE_CAPTURE, KEY_ESCAPE)
	_bind_key(ACTIONS.TOGGLE_MOUSE_CAPTURE, KEY_F12, false)


func _bind_key(action_name: StringName, keycode: int, clear_existing: bool = true) -> void:
	var event := InputEventKey.new()
	event.keycode = keycode
	_bind_event(action_name, event, clear_existing)


func _bind_mouse(action_name: StringName, button_index: int, clear_existing: bool = true) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = button_index
	_bind_event(action_name, event, clear_existing)


func _bind_event(action_name: StringName, event: InputEvent, clear_existing: bool) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	elif clear_existing:
		InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
