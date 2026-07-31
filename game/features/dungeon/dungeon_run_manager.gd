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

@export var map_view: DungeonMapView

var _floor_generator := PrototypeFloorGenerator.new()
var _boards: Array[DungeonBoard] = []

var _current_floor := -1
var _maximum_floors := 0
var _current_health := 0
var _maximum_health := 0
var _player_is_dead := false


func _ready() -> void:
	start_run()

func start_run() -> void:
	_maximum_floors = 10
	_maximum_health = 10

	_boards.clear()
	_current_floor = 0
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
	# Assert that it's a valid number
	assert(floor_number >= 0 and floor_number < _maximum_floors)
	
	while _boards.size() < floor_number:
		var generated_board: DungeonBoard = _floor_generator.generate()
		assert(generated_board != null, "The floor generator returned no board.")
		_boards.append(generated_board)


func _render_current_board() -> void:
	var board := _boards[_current_floor]
	var render_data := board.to_render_data()
	map_view.render_board(render_data)
