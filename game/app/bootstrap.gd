extends Node

const CHISEL_INPUT_EXPORT_PATH := "res://game_data/input.gd"

@export var load_in_scene: PackedScene


func _ready() -> void:
	_sync_chisel_input_map()
	await get_tree().process_frame
	_load_default_scene()


func _sync_chisel_input_map() -> void:
	var input_script := load(CHISEL_INPUT_EXPORT_PATH)
	var input_export = input_script.new()
	input_export.sync_input_map()


func _load_default_scene() -> void:
	assert(get_tree().change_scene_to_packed(load_in_scene) == OK)
