class_name PrototypeFloorGenerator
extends RefCounted

const CARDINAL_DIRECTIONS := [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]


func generate(config: Dictionary) -> Dictionary:
	var width := maxi(1, int(config.get("board_width", 8)))
	var height := maxi(1, int(config.get("board_height", 8)))
	var size := Vector2i(width, height)
	var middle_x := floori(width / 2.0)
	var player_cell := Vector2i(middle_x, height - 1)
	var exit_cell := Vector2i(middle_x, 0)
	var tiles: Array[Dictionary] = []

	for y in range(height):
		for x in range(width):
			var cell := Vector2i(x, y)
			if _should_strip_cell(cell, size, player_cell, exit_cell):
				continue

			tiles.append(
				{
					"cell": cell,
					"kind": &"floor",
					"revealed": true,
				}
			)

	assert(
		_is_orthogonally_connected(tiles),
		"Generated floor tiles must be connected through cardinal neighbors."
	)

	return {
		"dungeon_id": config.get("dungeon_id", &"prototype_dungeon"),
		"floor": int(config.get("floor", 1)),
		"seed": int(config.get("seed", 0)),
		"size": size,
		"tiles": tiles,
		"player_cell": player_cell,
		"exit_cell": exit_cell,
	}


func _should_strip_cell(
	cell: Vector2i,
	size: Vector2i,
	player_cell: Vector2i,
	exit_cell: Vector2i
) -> bool:
	if size.x < 4 or size.y < 4 or cell == player_cell or cell == exit_cell:
		return false

	var cutouts: Array[Vector2i] = [
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(size.x - 1, 0),
		Vector2i(size.x - 1, 1),
		Vector2i(0, size.y - 1),
		Vector2i(0, size.y - 2),
		Vector2i(size.x - 1, size.y - 1),
		Vector2i(size.x - 2, size.y - 1),
		Vector2i(size.x - 1, size.y - 2),
	]
	return cell in cutouts


func _is_orthogonally_connected(tiles: Array[Dictionary]) -> bool:
	if tiles.is_empty():
		return false

	var available := {}
	for tile in tiles:
		available[tile["cell"]] = true

	var first_cell: Vector2i = tiles[0]["cell"]
	var frontier: Array[Vector2i] = [first_cell]
	var visited := {}

	while not frontier.is_empty():
		var cell: Vector2i = frontier.pop_back()
		if visited.has(cell):
			continue
		visited[cell] = true

		for direction in CARDINAL_DIRECTIONS:
			var neighbor: Vector2i = cell + direction
			if available.has(neighbor) and not visited.has(neighbor):
				frontier.append(neighbor)

	return visited.size() == available.size()
