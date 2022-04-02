extends Node2D

export (int) var grid_size = 10

onready var play_area = $PlayArea
onready var block_scene = preload("res://src/scenes/Block.tscn")

func spawn_blocks():
	print("[Main Scene] Instancing blocks...")

	var block_size = play_area.scale / grid_size * 2
	var offset = play_area.scale * block_size + Vector2.ONE*7

	for y in range(grid_size):
		for x in range(grid_size):
			var instance = block_scene.instance()
			instance.scale = block_size
			instance.position = Vector2(
				8.0*x*block_size.x,
				8.0*y*block_size.y
			) - offset
			instance.modulate = Color(float(x)/grid_size,float(y)/grid_size, 0)
			add_child(instance) 

func _ready():
	spawn_blocks()
