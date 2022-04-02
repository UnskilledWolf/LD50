extends Node2D

export (int) var grid_size = 10 # Everything proboaply breaks if this changes

onready var play_area = $PlayArea
onready var block_scene = preload("res://src/scenes/Block.tscn")

var block_size = Vector2.ZERO

var blocks = []

func spawn_blocks():
	print("[Main Scene] Instancing blocks...")

	block_size = play_area.scale / grid_size * 2
	var offset = play_area.scale * block_size + Vector2.ONE*7 # Make this work better

	for y in range(grid_size):
		var tmp = []
		for x in range(grid_size):
			var instance = block_scene.instance()
			instance.scale = Vector2.ZERO
			instance.position = Vector2(
				8.0*x*block_size.x,
				8.0*y*block_size.y
			) - offset
			# instance.modulate = Color(float(x)/grid_size,float(y)/grid_size, 0)

			tmp.append(instance)
			add_child(instance)
		blocks.append(tmp)

func _ready():
	spawn_blocks()
	blocks[9][9].set_block_scale(block_size, 5, true)
