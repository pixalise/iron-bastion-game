extends CharacterBody3D

const CHISEL_INPUT := preload("res://game_data/input.gd")
const INPUT_BINDINGS := preload("res://game_data/tables/input_bindings.gd")

@export_node_path("Terrain3D") var terrain_path: NodePath
@export_node_path("Node3D") var simulation_bootstrap_path: NodePath
@export var move_speed: float = 30.0
@export var rotation_speed: float = 1.8
@export var terrain_height_offset: float = 0.0

var _terrain: Terrain3D


func _ready() -> void:
	if not terrain_path.is_empty():
		_set_terrain(get_node(terrain_path) as Terrain3D)
		return

	assert(not simulation_bootstrap_path.is_empty())
	var simulation_bootstrap := get_node(simulation_bootstrap_path) as Node
	assert(simulation_bootstrap != null)
	assert(simulation_bootstrap.has_signal("terrain_generated"))
	simulation_bootstrap.terrain_generated.connect(_on_terrain_generated)

	var generated_terrain := simulation_bootstrap.get("terrain") as Terrain3D
	if generated_terrain != null:
		_set_terrain(generated_terrain)


func _physics_process(delta: float) -> void:
	if _terrain == null:
		return

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


func _snap_to_terrain() -> void:
	var terrain_height := _terrain.data.get_height(global_position)
	assert(not is_nan(terrain_height))
	global_position.y = terrain_height + terrain_height_offset


func _on_terrain_generated(terrain: Terrain3D, _config: Resource) -> void:
	_set_terrain(terrain)


func _set_terrain(terrain: Terrain3D) -> void:
	assert(terrain != null)
	_terrain = terrain
	_snap_to_terrain()
