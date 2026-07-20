extends Node

const CHISEL_INPUT_EXPORT_PATH := "res://game_data/input.gd"

@export var load_in_scene: PackedScene


func _ready() -> void:
	_sync_chisel_input_map()
	await get_tree().process_frame
	_load_default_scene()


func _sync_chisel_input_map() -> bool:
	if not ResourceLoader.exists(CHISEL_INPUT_EXPORT_PATH):
		return false
	var input_script := load(CHISEL_INPUT_EXPORT_PATH)
	var input_export = input_script.new()
	input_export.sync_input_map()
	return true


func _load_default_scene() -> void:
	if load_in_scene == null:
		push_warning("Bootstrap has no load_in_scene assigned.")
		return

	var result := get_tree().change_scene_to_packed(load_in_scene)
	if result != OK:
		push_error("Failed to change to bootstrap load_in_scene: %s" % error_string(result))
