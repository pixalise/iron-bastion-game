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
var _zoom_distance: float = 0.0


func _ready() -> void:
	_follow_target = get_node_or_null(follow_target_path) as Node3D
	_locked_pitch = global_rotation.x
	_locked_roll = global_rotation.z

	if _follow_target == null:
		push_warning("RTS camera has no follow target.")
		return

	global_rotation = _locked_rotation()
	global_position = _base_camera_position()
	_zoom_distance = _base_focus_distance()
	_apply_camera_transform()


func _physics_process(_delta: float) -> void:
	if _follow_target == null:
		return

	_update_zoom()
	_apply_camera_transform()


func _update_zoom() -> void:
	if CHISEL_INPUT.is_action_just_pressed(INPUT_BINDINGS.Id.CAMERA_ZOOM_IN):
		_zoom_distance = clampf(
			_zoom_distance - zoom_step, min_follow_distance, max_follow_distance
		)

	if CHISEL_INPUT.is_action_just_pressed(INPUT_BINDINGS.Id.CAMERA_ZOOM_OUT):
		_zoom_distance = clampf(
			_zoom_distance + zoom_step, min_follow_distance, max_follow_distance
		)


func _apply_camera_transform() -> void:
	global_rotation = _locked_rotation()
	global_position = _focus_point(_base_camera_position()) - _view_direction() * _zoom_distance


func _base_camera_position() -> Vector3:
	var follow_offset := _follow_target.global_transform.basis.z * follow_distance
	follow_offset.y = follow_height

	return _follow_target.global_position + follow_offset


func _base_focus_distance() -> float:
	return clampf(
		_base_camera_position().distance_to(_focus_point(_base_camera_position())),
		min_follow_distance,
		max_follow_distance
	)


func _focus_point(camera_position: Vector3) -> Vector3:
	var direction := _view_direction()
	if is_zero_approx(direction.y):
		return _follow_target.global_position

	var distance_to_target_height := (
		(_follow_target.global_position.y - camera_position.y) / direction.y
	)
	if distance_to_target_height <= 0.0:
		return _follow_target.global_position

	return camera_position + direction * distance_to_target_height


func _locked_rotation() -> Vector3:
	return Vector3(_locked_pitch, _follow_target.global_rotation.y, _locked_roll)


func _view_direction() -> Vector3:
	return -global_transform.basis.z.normalized()
