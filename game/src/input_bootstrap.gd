extends Node

const CHISEL_INPUT_EXPORT_PATH := "res://game_data/input.gd"


func _ready() -> void:
	_apply_chisel_input_map()


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
