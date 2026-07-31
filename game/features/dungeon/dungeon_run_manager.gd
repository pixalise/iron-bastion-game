class_name DungeonRunManager
extends Control

const PrototypeFloorGenerator := preload(
	"res://game/features/dungeon/exploration/prototype_floor_generator.gd"
)
const PROTOTYPE_RUN_CONFIG := {
	"dungeon_id": &"prototype_dungeon",
	"maximum_floors": 10,
	"starting_health": 10,
	"seed": 1337,
	"board_width": 8,
	"board_height": 8,
}

signal player_died
signal health_changed(current_health: int, maximum_health: int)
signal floor_changed(current_floor: int)
signal board_changed(board_data: Dictionary)

@export var map_view: DungeonMapView

var _floor_generator := PrototypeFloorGenerator.new()
var _run_config: Dictionary = {}
var _boards: Array[DungeonBoard] = []

var _current_floor := 0
var _maximum_floors := 0
var _current_health := 0
var _maximum_health := 0
var _player_is_dead := false


func _ready() -> void:
	if map_view == null:
		push_error("DungeonRunManager requires a map view.")
		return
	start_run(PROTOTYPE_RUN_CONFIG)


func start_run(config: Dictionary) -> void:
	assert(_current_floor == 0, "This run has already started.")

	_maximum_floors = int(config.get("maximum_floors", 0))
	_maximum_health = int(config.get("starting_health", 0))
	assert(_maximum_floors > 0, "maximum_floors must be greater than zero.")
	assert(_maximum_health > 0, "starting_health must be greater than zero.")

	_run_config = config.duplicate(true)
	_boards.clear()
	_current_floor = 1
	_current_health = _maximum_health
	_player_is_dead = false

	_ensure_board_exists(_current_floor)
	_render_current_board()
	floor_changed.emit(_current_floor)
	health_changed.emit(_current_health, _maximum_health)


func advance_floor() -> bool:
	if _player_is_dead or _current_floor >= _maximum_floors:
		return false

	_current_floor += 1
	_ensure_board_exists(_current_floor)
	_render_current_board()
	floor_changed.emit(_current_floor)
	return true


func retreat_floor() -> bool:
	if _player_is_dead or _current_floor <= 1:
		return false

	_current_floor -= 1
	_render_current_board()
	floor_changed.emit(_current_floor)
	return true


func damage_player(amount: int) -> void:
	if amount <= 0 or _player_is_dead:
		return

	_current_health = maxi(0, _current_health - amount)
	health_changed.emit(_current_health, _maximum_health)

	if _current_health == 0:
		_player_is_dead = true
		player_died.emit()


func heal_player(amount: int) -> void:
	if amount <= 0 or _player_is_dead:
		return

	_current_health = mini(_maximum_health, _current_health + amount)
	health_changed.emit(_current_health, _maximum_health)


func get_current_board() -> DungeonBoard:
	var board := _current_board()
	return board.copy() if board != null else null


func get_board_for_floor(floor_number: int) -> DungeonBoard:
	if floor_number <= 0 or floor_number > _boards.size():
		return null
	return _boards[floor_number - 1].copy()


func get_generated_board_count() -> int:
	return _boards.size()


func get_current_floor() -> int:
	return _current_floor


func get_current_health() -> int:
	return _current_health


func get_maximum_health() -> int:
	return _maximum_health


func is_player_dead() -> bool:
	return _player_is_dead


func _ensure_board_exists(floor_number: int) -> void:
	assert(floor_number > 0 and floor_number <= _maximum_floors)

	while _boards.size() < floor_number:
		var floor_config := _run_config.duplicate(true)
		floor_config["floor"] = _boards.size() + 1

		var generated_board: DungeonBoard = _floor_generator.generate(floor_config)
		assert(generated_board != null, "The floor generator returned no board.")
		_boards.append(generated_board)


func _current_board() -> DungeonBoard:
	if _current_floor <= 0 or _current_floor > _boards.size():
		return null
	return _boards[_current_floor - 1]


func _render_current_board() -> void:
	var board := _current_board()
	if board == null:
		return

	var render_data := board.to_render_data()
	if map_view != null:
		map_view.render_board(render_data)
	board_changed.emit(render_data.duplicate(true))
