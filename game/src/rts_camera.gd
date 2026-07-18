extends Camera3D

@export_node_path("Node3D") var follow_target_path: NodePath
@export var follow_height: float = 36.0
@export var follow_distance: float = 36.0
@export_range(1.0, 30.0, 0.5) var follow_lerp_speed: float = 12.0

var _follow_target: Node3D


func _ready() -> void:
	_follow_target = get_node_or_null(follow_target_path) as Node3D

	if _follow_target == null:
		push_warning("RTS camera has no follow target.")
		return

	_snap_to_follow_target()


func _physics_process(delta: float) -> void:
	if _follow_target == null:
		return

	_follow_target_from_camera(delta)


func _follow_target_from_camera(delta: float) -> void:
	var desired_position := _desired_camera_position()
	var follow_weight: float = clamp(follow_lerp_speed * delta, 0.0, 1.0)

	global_position = global_position.lerp(desired_position, follow_weight)
	look_at(_follow_target.global_position, Vector3.UP)


func _snap_to_follow_target() -> void:
	global_position = _desired_camera_position()
	look_at(_follow_target.global_position, Vector3.UP)


func _desired_camera_position() -> Vector3:
	var follow_offset := _follow_target.global_transform.basis.z * follow_distance
	follow_offset.y = follow_height

	return _follow_target.global_position + follow_offset
