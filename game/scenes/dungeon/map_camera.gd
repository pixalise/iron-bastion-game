extends Camera2D

@export var zoom_step := 0.1
@export var minimum_zoom := 0.5
@export var maximum_zoom := 3.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			self.position -= event.relative / self.zoom

	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_camera_zoom(self.zoom.x + zoom_step)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_camera_zoom(self.zoom.x - zoom_step)


func set_camera_zoom(value: float) -> void:
	value = clampf(value, minimum_zoom, maximum_zoom)
	self.zoom = Vector2(value, value)
