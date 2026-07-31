class_name DungeonMapCamera
extends Camera2D

const MINIMUM_FIT_ZOOM := 0.5
const MAXIMUM_FIT_ZOOM := 3.0


func frame_rect(world_rect: Rect2, padding: float = 0.0) -> void:
	if world_rect.size.x <= 0.0 or world_rect.size.y <= 0.0:
		return

	position = world_rect.get_center()

	var viewport_size := get_viewport_rect().size
	var usable_size := Vector2(
		maxf(1.0, viewport_size.x - padding * 2.0),
		maxf(1.0, viewport_size.y - padding * 2.0)
	)
	var fit_zoom := clampf(
		minf(
			usable_size.x / world_rect.size.x,
			usable_size.y / world_rect.size.y
		),
		MINIMUM_FIT_ZOOM,
		MAXIMUM_FIT_ZOOM
	)
	zoom = Vector2.ONE * fit_zoom
