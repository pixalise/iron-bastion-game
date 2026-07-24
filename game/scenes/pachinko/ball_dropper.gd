extends MeshInstance3D

@export_category("Dropper Settings")
@export var muzzle: Node3D

@export_category("Ball Scene")
@export var ball_scene: PackedScene
@export var ball_spawn_position := Vector3(0.0, 0.75, 0.2)

func _physics_process(_delta: float) -> void:
	if ChiselInput.is_action_just_pressed(ChiselInputBindings.Id.ACTION):
		spawn_ball()

func spawn_ball() -> void:
	var ball := ball_scene.instantiate() as Node3D
	assert(ball != null, "Ball scene root must inherit from Node3D.")
	add_child(ball)
	ball.position = ball_spawn_position

func _update(_delta: float):
	if(ChiselInput.is_action_pressed(ChiselInputBindings.Id.PADDLE_LEFT)):
		pass
	if(ChiselInput.is_action_pressed(ChiselInputBindings.Id.PADDLE_RIGHT)):
		pass
