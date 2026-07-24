extends Node3D

@export_category("Peg Scene")
@export var peg_scene: PackedScene

@export_category("Peg Spawn Area")
@export var peg_spawn_area: MeshInstance3D

@export_category("Peg Spacing")
@export_range(0.05, 10.0, 0.05) var horizontal_spacing: float = 0.65
@export_range(0.05, 10.0, 0.05) var vertical_spacing: float = 0.55
@export_range(0.0, 1.0, 0.05) var odd_row_stagger_ratio: float = 0.5
@export var peg_z_offset: float = 0.0


func _ready() -> void:
	generate_peg_board()


func generate_peg_board() -> void:
	var bounds := _spawn_area_bounds()

	var left := bounds.position.x
	var right := bounds.position.x + bounds.size.x
	var top := bounds.position.y + bounds.size.y
	var bottom := bounds.position.y
	var row := 0
	var y := top

	while y >= bottom:
		var row_stagger := 0.0
		if row % 2 == 1:
			row_stagger = horizontal_spacing * odd_row_stagger_ratio
		var x := left + row_stagger

		while x <= right:
			if not _spawn_peg(Vector3(x, y, peg_z_offset)):
				return
			x += horizontal_spacing

		row += 1
		y = top - float(row) * vertical_spacing

	peg_spawn_area.visible = false


func _spawn_area_bounds() -> AABB:
	var source_aabb := peg_spawn_area.mesh.get_aabb()
	var has_point := false
	var bounds_min := Vector3.ZERO
	var bounds_max := Vector3.ZERO

	for endpoint_index in range(8):
		var source_point := source_aabb.get_endpoint(endpoint_index)
		var local_point := to_local(peg_spawn_area.to_global(source_point))
		if not has_point:
			bounds_min = local_point
			bounds_max = local_point
			has_point = true
		else:
			bounds_min = bounds_min.min(local_point)
			bounds_max = bounds_max.max(local_point)

	return AABB(bounds_min, bounds_max - bounds_min)


func _spawn_peg(spawn_position: Vector3) -> bool:
	var instance := peg_scene.instantiate()
	var peg := instance as Node3D
	add_child(peg)
	peg.position = spawn_position
	return true
