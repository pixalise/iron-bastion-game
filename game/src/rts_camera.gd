extends Camera3D

const CHISEL_INPUT := preload("res://game_data/input.gd")
const INPUT_BINDINGS := preload("res://game_data/tables/input_bindings.gd")

@export_node_path("Node3D") var follow_target_path: NodePath
@export var follow_height: float = 36.0
@export var follow_distance: float = 36.0
@export var zoom_step: float = 4.0
@export var min_follow_distance: float = 12.0
@export var max_follow_distance: float = 120.0

var _follow_target: Node3D
var _locked_pitch: float = 0.0
var _locked_roll: float = 0.0


func _ready() -> void:
	_follow_target = get_node_or_null(follow_target_path) as Node3D
	_locked_pitch = global_rotation.x
	_locked_roll = global_rotation.z

	if _follow_target == null:
		push_warning("RTS camera has no follow target.")
		return

	_apply_camera_transform()


func _physics_process(_delta: float) -> void:
	if _follow_target == null:
		return

	_update_zoom()
	_apply_camera_transform()


func _update_zoom() -> void:
	if CHISEL_INPUT.is_action_just_pressed(INPUT_BINDINGS.Id.CAMERA_ZOOM_IN):
		follow_distance = clampf(
			follow_distance - zoom_step, min_follow_distance, max_follow_distance
		)

	if CHISEL_INPUT.is_action_just_pressed(INPUT_BINDINGS.Id.CAMERA_ZOOM_OUT):
		follow_distance = clampf(
			follow_distance + zoom_step, min_follow_distance, max_follow_distance
		)


func _apply_camera_transform() -> void:
	global_position = _desired_camera_position()
	global_rotation = Vector3(_locked_pitch, _follow_target.global_rotation.y, _locked_roll)


func _desired_camera_position() -> Vector3:
	var follow_offset := _follow_target.global_transform.basis.z * follow_distance
	follow_offset.y = follow_height

	return _follow_target.global_position + follow_offset
