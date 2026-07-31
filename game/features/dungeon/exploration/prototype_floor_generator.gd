class_name PrototypeFloorGenerator
extends RefCounted

const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]


func generate(width: int, height: int) -> DungeonBoard:
	var size := Vector2i(width, height)
	var middle_x := floori(width / 2.0)
	var player_cell := Vector2i(middle_x, height - 1)
	var exit_cell := Vector2i(middle_x, 0)

	var board := DungeonBoard.new()
	board.initialize(size)
	board.player_index = board.index_of(player_cell)
	board.exit_index = board.index_of(exit_cell)

	for y in range(height):
		for x in range(width):
			var cell := Vector2i(x, y)
			if _should_strip_cell(cell, size, player_cell, exit_cell):
				continue
			board.set_cell(cell, DungeonBoard.CellKind.FLOOR)

	assert(
		_is_orthogonally_connected(board),
		"Generated floor cells must be connected through cardinal neighbors."
	)
	return board


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


func _is_orthogonally_connected(board: DungeonBoard) -> bool:
	var first_index := -1
	for index in range(board.flags.size()):
		if board.has_cell(index):
			first_index = index
			break

	if first_index < 0:
		return false

	var visited := PackedByteArray()
	visited.resize(board.flags.size())

	var frontier: Array[int] = [first_index]
	var visited_count := 0

	while not frontier.is_empty():
		var index: int = frontier.pop_back()
		if visited[index] != 0:
			continue

		visited[index] = 1
		visited_count += 1
		var cell := board.cell_of(index)

		for direction in CARDINAL_DIRECTIONS:
			var neighbor := cell + direction
			if not board.has_cell_at(neighbor):
				continue

			var neighbor_index := board.index_of(neighbor)
			if visited[neighbor_index] == 0:
				frontier.append(neighbor_index)

	return visited_count == board.active_cell_count()
