class_name TerrainGenerator
extends Node3D

var config: Resource

var terrain: Terrain3D


func create_terrain(terrain_config: Resource) -> Terrain3D:
	assert(terrain_config != null)

	config = terrain_config
	var generated_terrain := Terrain3D.new()
	generated_terrain.name = "Terrain3D"
	generated_terrain.region_size = config.region_size

	add_child(generated_terrain, true)
	generated_terrain.data.import_images(
		[_create_heightmap(), null, null], config.terrain_origin, 0.0, config.height_scale
	)

	terrain = generated_terrain
	return generated_terrain


func _create_heightmap() -> Image:
	var noise := FastNoiseLite.new()
	noise.seed = config.noise_seed
	noise.frequency = config.noise_frequency

	var flatten_mask := _create_flatten_mask()
	var image := Image.create_empty(
		config.heightmap_size, config.heightmap_size, false, Image.FORMAT_RF
	)
	for x in image.get_width():
		for y in image.get_height():
			var height := remap(noise.get_noise_2d(x, y), -1.0, 1.0, 0.0, 1.0)
			height *= flatten_mask.get_pixel(x, y).r
			image.set_pixel(x, y, Color(height, 0.0, 0.0, 1.0))

	return image


func _create_flatten_mask() -> Image:
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = config.flatten_mask_seed
	noise.frequency = config.flatten_mask_frequency

	var image := Image.create_empty(
		config.heightmap_size, config.heightmap_size, false, Image.FORMAT_RF
	)
	for x in image.get_width():
		for y in image.get_height():
			var mask_value := remap(noise.get_noise_2d(x, y), -1.0, 1.0, 0.0, 1.0)
			var flatten_weight := smoothstep(
				config.flatten_threshold,
				minf(config.flatten_threshold + config.flatten_softness, 1.0),
				mask_value
			)
			image.set_pixel(x, y, Color(flatten_weight, 0.0, 0.0, 1.0))

	return image
