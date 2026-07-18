extends Node3D

const INPUT_BINDINGS := preload("res://game_data/tables/input_bindings.gd")

@export var move_speed: float = 30.0
@export var rotation_speed: float = 1.8


func _physics_process(delta: float) -> void:
	_update_rotation(delta)
	_update_position(delta)


func _update_rotation(delta: float) -> void:
	var rotation_input := Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_ROTATE_RIGHT))
	rotation_input -= Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_ROTATE_LEFT))

	if is_zero_approx(rotation_input):
		return

	rotate_y(rotation_input * rotation_speed * delta)


func _update_position(delta: float) -> void:
	var input_vector := Vector2(
		(
			Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_RIGHT))
			- Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_LEFT))
		),
		(
			Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_FORWARD))
			- Input.get_action_strength(_action(INPUT_BINDINGS.Id.CAMERA_BACKWARD))
		)
	)

	if input_vector.length_squared() > 1.0:
		input_vector = input_vector.normalized()

	if input_vector.is_zero_approx():
		return

	var right := global_transform.basis.x
	var forward := -global_transform.basis.z
	var move_direction := right * input_vector.x + forward * input_vector.y

	global_position += move_direction * move_speed * delta


func _action(action_id: int) -> StringName:
	return StringName(String(INPUT_BINDINGS.SLUGS[action_id]).to_lower())
