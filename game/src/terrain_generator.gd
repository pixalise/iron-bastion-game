extends Node3D

@export_range(256, 4096, 256) var heightmap_size: int = 1024
@export_range(256, 4096, 256) var region_size: int = 1024
@export var height_scale: float = 48.0
@export var noise_frequency: float = 0.004
@export var noise_seed: int = 1
@export var terrain_origin: Vector3 = Vector3(-512.0, 0.0, -512.0)

var terrain: Terrain3D


func _ready() -> void:
	terrain = create_terrain()


func create_terrain() -> Terrain3D:
	var generated_terrain := Terrain3D.new()
	generated_terrain.name = "Terrain3D"
	generated_terrain.region_size = region_size

	add_child(generated_terrain, true)
	generated_terrain.data.import_images(
		[_create_heightmap(), null, null], terrain_origin, 0.0, height_scale
	)

	return generated_terrain


func _create_heightmap() -> Image:
	var noise := FastNoiseLite.new()
	noise.seed = noise_seed
	noise.frequency = noise_frequency

	var image := Image.create_empty(heightmap_size, heightmap_size, false, Image.FORMAT_RF)
	for x in image.get_width():
		for y in image.get_height():
			var height := remap(noise.get_noise_2d(x, y), -1.0, 1.0, 0.0, 1.0)
			image.set_pixel(x, y, Color(height, 0.0, 0.0, 1.0))

	return image
