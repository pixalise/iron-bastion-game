extends SceneTree


func _initialize() -> void:
	assert(ClassDB.class_exists("GraphiteWorld"), "GraphiteWorld GDExtension class is not loaded.")

	var world = ClassDB.instantiate("GraphiteWorld")
	assert(world != null, "Could not instantiate GraphiteWorld.")

	world.configure_navigation_grid(2, 2, 1.0)
	var cells := PackedByteArray([0, 1, 2, 16])
	world.set_navigation_cells(cells)
	assert(world.is_navigation_grid_configured(), "Graphite navigation grid was not configured.")
	assert(world.get_navigation_cell_count() == 4, "Graphite navigation cell count is wrong.")
	assert(world.get_navigation_cells() == cells, "Graphite navigation cells were not stored.")

	quit()
