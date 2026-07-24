extends Node3D

@export_category("Peg Scene")
@export var peg_scene: PackedScene

@export_category("Ball Scene")
@export var ball_scene: PackedScene
@export var ball_spawn_position := Vector3(0.0, 0.75, 0.2)

@export_category("Board Size")
@export_range(1, 50, 1) var row_count: int = 12
@export_range(1, 50, 1) var pegs_per_row: int = 10

@export_category("Peg Spacing")
@export var horizontal_spacing: float = 0.65
@export var vertical_spacing: float = 0.55
@export_range(0.0, 1.0, 0.05) var odd_row_stagger_ratio: float = 0.5
@export var peg_z_offset: float = 0.0


func _ready() -> void:
	generate_peg_board()


func _physics_process(_delta: float) -> void:
	if ChiselInput.is_action_just_pressed(ChiselInputBindings.Id.ACTION):
		spawn_ball()


func spawn_ball() -> void:
	var ball := ball_scene.instantiate() as Node3D
	assert(ball != null, "Ball scene root must inherit from Node3D.")
	add_child(ball)
	ball.position = ball_spawn_position


func generate_peg_board() -> void:
	if peg_scene == null:
		push_error("No peg scene assigned.")
		return

	for row in range(row_count):
		var row_width := float(pegs_per_row - 1) * horizontal_spacing
		var row_stagger := 0.0
		if row % 2 == 1:
			row_stagger = horizontal_spacing * odd_row_stagger_ratio
		var starting_x := -row_width * 0.5 + row_stagger

		for column in range(pegs_per_row):
			var instance := peg_scene.instantiate()

			if not instance is Node3D:
				instance.queue_free()
				push_error("Peg scene root must inherit from Node3D.")
				return

			var peg := instance as Node3D
			add_child(peg)

			peg.position = Vector3(
				starting_x + column * horizontal_spacing, -row * vertical_spacing, peg_z_offset
			)
