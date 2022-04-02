extends Node2D

export (int) var grid_size = 10 # Everything proboaply breaks if this changes
export (float) var speed = 0.1 # About 1 minute

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

			instance.x = x
			instance.y = y

			tmp.append(instance)
			add_child(instance)
		blocks.append(tmp)

func _ready():
	GameManager.connect("block_complete", self, "_on_block_complete")

	spawn_blocks()
	_on_block_complete(grid_size, grid_size-1)

func _on_block_complete(x,y):
	var px=x-1
	var py=y
	
	if px < 0:
		py = y-1
		px = grid_size-1
	
	if py < 0:
		print("[Main Scene] No Blocks Left!")
		return
	
	blocks[py][px].set_block_scale(block_size,speed, true)
