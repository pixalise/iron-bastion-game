extends Node3D

signal terrain_generated(terrain: Terrain3D, config: Resource)

@export var terrain_config: Resource
@export_node_path("Node3D") var terrain_generator_path: NodePath = ^"TerrainGenerator"

var terrain: Terrain3D


func _ready() -> void:
	assert(terrain_config != null)

	var terrain_generator := get_node(terrain_generator_path) as Node
	assert(terrain_generator != null)
	assert(terrain_generator.has_method("create_terrain"))

	terrain = terrain_generator.create_terrain(terrain_config)
	terrain_generated.emit(terrain, terrain_config)
