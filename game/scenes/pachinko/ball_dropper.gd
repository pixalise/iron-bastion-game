extends MeshInstance3D

@export_category("Dropper Settings")
@export var muzzle: Node3D

@export_category("Ball Scene")
@export var ball_scene: PackedScene
@export var ball_spawn_position := Vector3(0.0, 0.75, 0.2)

@export_category("Movement")
@export var movement_bounds: MeshInstance3D
@export var movement_speed: float = 4.0


func _physics_process(delta: float) -> void:
	if ChiselInput.is_action_just_pressed(ChiselInputBindings.Id.ACTION):
		spawn_ball()

	_update(delta)


func spawn_ball() -> void:
	var ball := ball_scene.instantiate() as Node3D
	assert(ball != null, "Ball scene root must inherit from Node3D.")
	get_tree().current_scene.add_child(ball)
	ball.global_position = muzzle.global_position


func _update(delta: float) -> void:
	var movement_direction := 0.0
	if ChiselInput.is_action_pressed(ChiselInputBindings.Id.PADDLE_LEFT):
		movement_direction -= 1.0
	if ChiselInput.is_action_pressed(ChiselInputBindings.Id.PADDLE_RIGHT):
		movement_direction += 1.0

	var bounds := _movement_bounds()
	var next_global_position := global_position
	next_global_position.x = clampf(
		next_global_position.x + movement_direction * movement_speed * delta,
		bounds.position.x,
		bounds.position.x + bounds.size.x
	)
	global_position = next_global_position


func _movement_bounds() -> AABB:
	var source_aabb := movement_bounds.mesh.get_aabb()
	var bounds_min := movement_bounds.to_global(source_aabb.get_endpoint(0))
	var bounds_max := bounds_min

	for endpoint_index in range(1, 8):
		var global_point := movement_bounds.to_global(source_aabb.get_endpoint(endpoint_index))
		bounds_min = bounds_min.min(global_point)
		bounds_max = bounds_max.max(global_point)

	return AABB(bounds_min, bounds_max - bounds_min)
