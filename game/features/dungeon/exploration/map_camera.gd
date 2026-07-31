class_name DungeonMapCamera
extends Camera2D

@export var zoom_step := 0.1
@export var minimum_zoom := 0.5
@export var maximum_zoom := 3.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position -= event.relative / zoom

	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_camera_zoom(zoom.x + zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_camera_zoom(zoom.x - zoom_step)


func set_camera_zoom(value: float) -> void:
	value = clampf(value, minimum_zoom, maximum_zoom)
	zoom = Vector2(value, value)


func frame_rect(world_rect: Rect2, padding: float = 0.0) -> void:
	if world_rect.size.x <= 0.0 or world_rect.size.y <= 0.0:
		return

	position = world_rect.get_center()

	var viewport_size := get_viewport_rect().size
	var usable_size := Vector2(
		maxf(1.0, viewport_size.x - padding * 2.0),
		maxf(1.0, viewport_size.y - padding * 2.0)
	)
	var fit_zoom := minf(
		usable_size.x / world_rect.size.x,
		usable_size.y / world_rect.size.y
	)
	set_camera_zoom(fit_zoom)
