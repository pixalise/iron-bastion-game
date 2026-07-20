extends SceneTree


func _initialize() -> void:
	assert(ClassDB.class_exists("GraphiteMath"), "GraphiteMath GDExtension class is not loaded.")

	var math = ClassDB.instantiate("GraphiteMath")
	assert(math != null, "Could not instantiate GraphiteMath.")
	assert(math.add_numbers(2.0, 3.0) == 5.0, "GraphiteMath.add_numbers returned the wrong result.")

	quit()
