extends Node2D

# MapWorld.gd
@export var camera: Camera2D

func _ready() -> void:
	camera.make_current()
