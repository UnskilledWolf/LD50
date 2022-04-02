extends Node2D

export (int) var grid_size = 10 # Everything proboaply breaks if this changes
export (float) var speed = 1 # About 1 minute

onready var play_area = $PlayArea
onready var block_scene = preload("res://src/scenes/Block.tscn")

var block_size = Vector2.ZERO
var blocks = []
var rng = RandomNumberGenerator.new()

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

func count_block_neighbors(x,y) -> int:
	var count = 0

	for oy in range(-1, 2):
		for ox in range(-1,2):
			if y + oy < 0 or y + oy >= grid_size or x + ox < 0 or x + ox >= grid_size:
				count += 1 # The index is out of bounds
			elif blocks[y+oy][x+ox].target_collision == true:
				count += 1 # The index is actually colliding

	return count

func get_speed(b:int)->float:
	#y=-1.0064^{x}+\left(i+1\right) 
	# var y = pow(-1.0064,b)+2
	var y = -0.009*b+1
	print("[Main Scene] Current Speed: " + str(y))
	return y

func _ready():
	rng.randomize()
	GameManager.connect("block_complete", self, "_on_block_complete")

	spawn_blocks()
	blocks[9][9].set_block_scale(block_size, speed, true)

func _on_block_complete(x,y):
	var px=x
	var py=y

	# Check if there is remaining space next to the current cube
	if count_block_neighbors(x,y) < 8:
		# Fake Do-While Loop
		while true:
			var dir = rng.randi_range(0,3) 
			
			if dir == 0:
				px += 1
			elif dir == 1:
				px -= 1
			elif dir == 2:
				py += 1
			elif dir == 3:
				py -= 1
			else:
				print("Something went wrong!")
				return

			# Clamp to array bounds
			px = clamp(px, 0,grid_size-1)
			py = clamp(py, 0,grid_size-1)

			if not blocks[py][px].target_collision == true:
				GameManager.block_count += 1
				GameManager.block_count_real += 1
				blocks[py][px].set_block_scale(block_size,get_speed(GameManager.block_count), true)
				return
	# If not find a filled cube that does have the space
	else:
		print("[Main Scene] Searching for new start block")
		var max_runs = 1000
		while true:
			max_runs -= 1
			# Grab a random cube
			px = rng.randi_range(0,grid_size-1)
			py = rng.randi_range(0,grid_size-1)

			# Check that it's filled AND that it has empty neighbors
			if blocks[px][py].target_collision == true and count_block_neighbors(px,py) < 8:
				_on_block_complete(px,py) # Use that one instead
				return

			if max_runs <= 0:
				print("[Main Scene] Unable to find suitable block!")
				# Search all blocks
				for oy in range(grid_size):
					for ox in range(grid_size):
						if blocks[oy][ox].target_collision == false:
							print("[Main Scene] Found STRAY block at " + str(ox) + ", " + str(oy))
							blocks[oy][ox].set_block_scale(block_size,get_speed(GameManager.block_count), true)
							return
				
				print("[Main Scene] All blocks filled!")
				GameManager.game_over("All blocks filled!")
				return
