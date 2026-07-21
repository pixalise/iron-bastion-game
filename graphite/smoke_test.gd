extends SceneTree


func _initialize() -> void:
	assert(ClassDB.class_exists("GraphiteWorld"), "GraphiteWorld GDExtension class is not loaded.")

	var world = ClassDB.instantiate("GraphiteWorld")
	assert(world != null, "Could not instantiate GraphiteWorld.")

	world.configure_simulation_grid(2, 2, 1.0)
	var cells := PackedByteArray([0, 1, 2, 16])
	world.set_simulation_cells(cells)
	assert(world.is_simulation_grid_configured(), "Graphite simulation grid was not configured.")
	assert(world.get_simulation_cell_count() == 4, "Graphite simulation cell count is wrong.")
	assert(world.get_simulation_cells() == cells, "Graphite simulation cells were not stored.")

	quit()
