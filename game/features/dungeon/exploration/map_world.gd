class_name DungeonMapView
extends Node2D

const UiTheme := preload("res://game/ui/theme/ui_theme.gd")

signal action_requested(action: StringName, payload: Dictionary)

@export var camera: DungeonMapCamera
@export_range(16.0, 256.0, 1.0) var tile_size := 64.0
@export_range(0.0, 16.0, 1.0) var tile_gap := 4.0

var _board_data: Dictionary = {}


func _ready() -> void:
	camera.make_current()
	get_viewport().size_changed.connect(_frame_board)


func render_board(board_data: Dictionary) -> void:
	_board_data = board_data.duplicate(true)
	queue_redraw()
	_frame_board.call_deferred()


func request_action(action: StringName, payload: Dictionary = {}) -> void:
	action_requested.emit(action, payload.duplicate(true))


func _draw() -> void:
	if _board_data.is_empty():
		return

	var bounds := _board_rect()
	draw_rect(bounds.grow(tile_gap), UiTheme.VOID)
	draw_rect(bounds.grow(tile_gap), UiTheme.STONE_MID, false, 3.0)

	for tile_data: Variant in _board_data.get("tiles", []):
		if not tile_data is Dictionary:
			continue

		var tile: Dictionary = tile_data
		var cell: Vector2i = tile.get("cell", Vector2i.ZERO)
		var revealed := bool(tile.get("revealed", false))
		var fill := UiTheme.STONE_SHADOW if revealed else UiTheme.CHARCOAL
		var rect := _cell_rect(cell)

		draw_rect(rect, fill)
		draw_rect(rect, UiTheme.STONE_MID, false, 2.0)

	_draw_exit(_board_data.get("exit_cell", Vector2i.ZERO))
	_draw_player(_board_data.get("player_cell", Vector2i.ZERO))


func _draw_player(cell: Vector2i) -> void:
	var center := Vector2(cell) * tile_size + Vector2.ONE * tile_size * 0.5
	var radius := tile_size * 0.18
	draw_circle(center, radius, UiTheme.CANDLE_GLOW)
	draw_arc(center, radius, 0.0, TAU, 24, UiTheme.RITUAL_RED, 3.0, true)


func _draw_exit(cell: Vector2i) -> void:
	var marker := _cell_rect(cell).grow(-tile_size * 0.22)
	draw_rect(marker, UiTheme.BLOOD_SHADOW)
	draw_rect(marker, UiTheme.CANDLE_GLOW, false, 3.0)


func _cell_rect(cell: Vector2i) -> Rect2:
	var inset := tile_gap * 0.5
	var origin := Vector2(cell) * tile_size + Vector2.ONE * inset
	var side := maxf(1.0, tile_size - tile_gap)
	return Rect2(origin, Vector2.ONE * side)


func _board_rect() -> Rect2:
	var board_size: Vector2i = _board_data.get("size", Vector2i.ZERO)
	return Rect2(Vector2.ZERO, Vector2(board_size) * tile_size)


func _frame_board() -> void:
	if _board_data.is_empty() or camera == null:
		return
	camera.frame_rect(_board_rect(), tile_size * 0.75)
