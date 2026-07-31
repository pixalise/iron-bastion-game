class_name DungeonBoard
extends RefCounted

enum CellKind {
	EMPTY,
	FLOOR,
}

const CELL_EXISTS := 1 << 0
const CELL_REVEALED := 1 << 1

var dungeon_id: StringName = &""
var floor := 0
var seed := 0
var size := Vector2i.ZERO

# Structure of arrays: every array uses the same row-major cell index.
var kinds := PackedByteArray()
var flags := PackedByteArray()

var player_index := -1
var exit_index := -1


func initialize(
	board_size: Vector2i,
	board_floor: int,
	board_seed: int,
	board_dungeon_id: StringName
) -> void:
	assert(board_size.x > 0 and board_size.y > 0, "Board dimensions must be positive.")

	size = board_size
	floor = board_floor
	seed = board_seed
	dungeon_id = board_dungeon_id

	var total_cells := size.x * size.y
	kinds.resize(total_cells)
	kinds.fill(CellKind.EMPTY)
	flags.resize(total_cells)
	flags.fill(0)


func index_of(cell: Vector2i) -> int:
	assert(is_in_bounds(cell), "Cell is outside the board.")
	return cell.y * size.x + cell.x


func cell_of(index: int) -> Vector2i:
	assert(index >= 0 and index < flags.size(), "Cell index is outside the board.")
	return Vector2i(index % size.x, floori(float(index) / float(size.x)))


func is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < size.x and cell.y < size.y


func has_cell(index: int) -> bool:
	return index >= 0 and index < flags.size() and flags[index] & CELL_EXISTS != 0


func has_cell_at(cell: Vector2i) -> bool:
	return is_in_bounds(cell) and has_cell(index_of(cell))


func set_cell(cell: Vector2i, kind: int, revealed: bool = false) -> void:
	var index := index_of(cell)
	kinds[index] = kind
	flags[index] = CELL_EXISTS | (CELL_REVEALED if revealed else 0)


func is_revealed(index: int) -> bool:
	return has_cell(index) and flags[index] & CELL_REVEALED != 0


func active_cell_count() -> int:
	var count := 0
	for index in range(flags.size()):
		if has_cell(index):
			count += 1
	return count


func copy() -> DungeonBoard:
	var snapshot := DungeonBoard.new()
	snapshot.dungeon_id = dungeon_id
	snapshot.floor = floor
	snapshot.seed = seed
	snapshot.size = size
	snapshot.kinds = kinds.duplicate()
	snapshot.flags = flags.duplicate()
	snapshot.player_index = player_index
	snapshot.exit_index = exit_index
	return snapshot


func to_render_data() -> Dictionary:
	var tiles: Array[Dictionary] = []

	for index in range(flags.size()):
		if not has_cell(index):
			continue

		tiles.append(
			{
				"cell": cell_of(index),
				"kind": int(kinds[index]),
				"revealed": is_revealed(index),
			}
		)

	return {
		"dungeon_id": dungeon_id,
		"floor": floor,
		"seed": seed,
		"size": size,
		"tiles": tiles,
		"player_cell": cell_of(player_index),
		"exit_cell": cell_of(exit_index),
	}
