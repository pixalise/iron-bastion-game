extends CharacterBody3D

const CHISEL_INPUT := preload("res://game_data/input.gd")
const INPUT_BINDINGS := preload("res://game_data/tables/input_bindings.gd")

@export_node_path("Terrain3D") var terrain_path: NodePath
@export var move_speed: float = 30.0
@export var rotation_speed: float = 1.8
@export var terrain_height_offset: float = 0.0

var _terrain: Terrain3D


func _ready() -> void:
	_resolve_terrain()
	_snap_to_terrain()


func _physics_process(delta: float) -> void:
	_resolve_terrain()
	_update_rotation(delta)
	_update_position(delta)
	_snap_to_terrain()


func _update_rotation(delta: float) -> void:
	var rotation_input := CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_ROTATE_RIGHT)
	rotation_input -= CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_ROTATE_LEFT)

	if is_zero_approx(rotation_input):
		return

	rotate_y(rotation_input * rotation_speed * delta)


func _update_position(delta: float) -> void:
	var input_vector := Vector2(
		(
			CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_RIGHT)
			- CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_LEFT)
		),
		(
			CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_FORWARD)
			- CHISEL_INPUT.get_action_strength(INPUT_BINDINGS.Id.CAMERA_BACKWARD)
		)
	)

	input_vector = input_vector.normalized()
	if input_vector.is_zero_approx():
		return

	var right := global_transform.basis.x
	var forward := -global_transform.basis.z
	var move_direction := right * input_vector.x + forward * input_vector.y
	move_direction.y = 0.0

	global_position += move_direction.normalized() * move_speed * delta


func _resolve_terrain() -> void:
	if _terrain != null:
		return

	_terrain = get_node_or_null(terrain_path) as Terrain3D


func _snap_to_terrain() -> void:
	if _terrain == null:
		return

	var terrain_height := _terrain.data.get_height(global_position)
	if is_nan(terrain_height):
		return

	global_position.y = terrain_height + terrain_height_offset
