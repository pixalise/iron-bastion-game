class_name TerrainGenerationConfig
extends Resource

@export_range(256, 4096, 256) var heightmap_size: int = 1024
@export_range(256, 4096, 256) var region_size: int = 1024
@export var height_scale: float = 64.0
@export var noise_frequency: float = 0.018
@export var noise_seed: int = 1
@export var flatten_mask_frequency: float = 0.0025
@export var flatten_mask_seed: int = 2
@export_range(0.0, 1.0, 0.01) var flatten_threshold: float = 0.72
@export_range(0.001, 1.0, 0.01) var flatten_softness: float = 0.08
@export var terrain_origin: Vector3 = Vector3(-512.0, 0.0, -512.0)
