extends Camera3D

@export_node_path("Node3D") var follow_target_path: NodePath
@export_node_path("Node3D") var lag_target_path: NodePath
@export var follow_height: float = 36.0
@export var follow_distance: float = 36.0
@export_range(0.0, 30.0, 0.5) var lag_smoothing: float = 10.0

var _follow_target: Node3D
var _lag_target: Node3D
var _lag_position: Vector3
var _lag_yaw: float = 0.0


func _ready() -> void:
	_follow_target = get_node_or_null(follow_target_path) as Node3D
	_lag_target = get_node_or_null(lag_target_path) as Node3D

	if _follow_target == null:
		push_warning("RTS camera has no follow target.")
		return

	_reset_lag_target()
	_apply_camera_transform()


func _physics_process(delta: float) -> void:
	if _follow_target == null:
		return

	_update_lag_target(delta)
	_apply_camera_transform()


func _update_lag_target(delta: float) -> void:
	var lag_weight := _lag_weight(delta)

	_lag_position = _lag_position.lerp(_follow_target.global_position, lag_weight)
	_lag_yaw = lerp_angle(_lag_yaw, _follow_target.global_rotation.y, lag_weight)

	if _lag_target != null:
		_lag_target.global_position = _lag_position
		_lag_target.global_rotation = Vector3(0.0, _lag_yaw, 0.0)


func _apply_camera_transform() -> void:
	global_position = _desired_camera_position()
	look_at(_lag_position, Vector3.UP)


func _reset_lag_target() -> void:
	_lag_position = _follow_target.global_position
	_lag_yaw = _follow_target.global_rotation.y

	if _lag_target != null:
		_lag_target.global_position = _lag_position
		_lag_target.global_rotation = Vector3(0.0, _lag_yaw, 0.0)


func _desired_camera_position() -> Vector3:
	var yaw_basis := Basis(Vector3.UP, _lag_yaw)
	var follow_offset := yaw_basis.z * follow_distance
	follow_offset.y = follow_height

	return _lag_position + follow_offset


func _lag_weight(delta: float) -> float:
	if lag_smoothing <= 0.0:
		return 1.0

	return 1.0 - exp(-lag_smoothing * delta)
