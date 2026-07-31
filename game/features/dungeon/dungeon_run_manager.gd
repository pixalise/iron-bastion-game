class_name DungeonRunManager
extends Control

const PrototypeFloorGenerator := preload("res://game/features/dungeon/exploration/prototype_floor_generator.gd")
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
signal map_action_requested(action: StringName, payload: Dictionary)

@export var map_view: DungeonMapView
var _prototype_floor_generator := PrototypeFloorGenerator.new()

var _run_config: Dictionary = {}
var _board: Dictionary = {}
var _floor_generator: Callable
var _current_floor := 0
var _maximum_floors := 0
var _current_health := 0
var _maximum_health := 0
var _player_is_dead := false


func _ready() -> void:
	if map_view == null:
		push_error("DungeonRunManager requires a map view.")
		return
	map_view.action_requested.connect(_on_map_action_requested)
	start_run(PROTOTYPE_RUN_CONFIG, _prototype_floor_generator.generate)


func start_run(config: Dictionary, floor_generator: Callable) -> void:
	assert(_current_floor == 0, "This run has already started.")
	assert(floor_generator.is_valid(), "A valid floor generator is required.")

	var maximum_floors := int(config.get("maximum_floors", 0))
	var starting_health := int(config.get("starting_health", 0))
	assert(maximum_floors > 0, "maximum_floors must be greater than zero.")
	assert(starting_health > 0, "starting_health must be greater than zero.")

	_run_config = config.duplicate(true)
	_floor_generator = floor_generator
	_current_floor = 1
	_maximum_floors = maximum_floors
	_current_health = starting_health
	_maximum_health = starting_health
	_player_is_dead = false

	_generate_current_floor()
	floor_changed.emit(_current_floor)
	health_changed.emit(_current_health, _maximum_health)


func advance_floor() -> bool:
	if _player_is_dead or _current_floor >= _maximum_floors:
		return false

	_current_floor += 1
	_generate_current_floor()
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


func get_board() -> Dictionary:
	return _board.duplicate(true)


func get_current_floor() -> int:
	return _current_floor


func get_current_health() -> int:
	return _current_health


func get_maximum_health() -> int:
	return _maximum_health


func is_player_dead() -> bool:
	return _player_is_dead


func _generate_current_floor() -> void:
	var floor_config := _run_config.duplicate(true)
	floor_config["floor"] = _current_floor

	var generated_board: Dictionary = _floor_generator.call(floor_config)
	_set_board(generated_board)


func _set_board(board_data: Dictionary) -> void:
	_board = board_data.duplicate(true)
	var snapshot := get_board()

	if map_view != null:
		map_view.render_board(snapshot)
	board_changed.emit(snapshot)


func _on_map_action_requested(action: StringName, payload: Dictionary) -> void:
	map_action_requested.emit(action, payload.duplicate(true))
