class_name PrototypeFloorGenerator
extends RefCounted


func generate(config: Dictionary) -> Dictionary:
	var width := maxi(1, int(config.get("board_width", 8)))
	var height := maxi(1, int(config.get("board_height", 8)))
	var size := Vector2i(width, height)
	var tiles: Array[Dictionary] = []

	for y in range(height):
		for x in range(width):
			tiles.append(
				{
					"cell": Vector2i(x, y),
					"kind": &"floor",
					"revealed": true,
				}
			)

	var middle_x := floori(width / 2.0)
	return {
		"dungeon_id": config.get("dungeon_id", &"prototype_dungeon"),
		"floor": int(config.get("floor", 1)),
		"seed": int(config.get("seed", 0)),
		"size": size,
		"tiles": tiles,
		"player_cell": Vector2i(middle_x, height - 1),
		"exit_cell": Vector2i(middle_x, 0),
	}
