extends Node

signal block_complete
signal block_failed
signal ray_destroy

var ability_names = [
	"Slow Blocks",
	"Drill",
	"Jump Boost",
	"Bomb",
	"Ray"
]

var ability_speeds = [
	40,
	50,
	60,
	90,
	100
]

var ability_icons = [
	preload("res://src/sprites/abilities/SlowBlocks.png"),
	preload("res://src/sprites/abilities/Drill.png"),
	preload("res://src/sprites/abilities/JumpBoost.png"),
	preload("res://src/sprites/abilities/Bomb.png"),
	preload("res://src/sprites/abilities/Ray.png")
]

onready var drill_scene = preload("res://src/scenes/Drill.tscn")

var timer_ref
var player_ref

var invoke_lock = false
var current_ability = 0
var block_count = 0 # Used for timing
var block_count_real = 0 # Used for score

func global_to_grid_pos(p:Vector2) -> Vector2:
	# x -280 280
	# y -280 280
	# Assuming the grid is the 10x10 and whatever size on screen...
	return Vector2(
		floor((0.5/280 * p.x + 0.5)*10),
		floor((0.5/280 * p.y + 0.5)*10)
	)
	# return Vector2(
	# 	floor(5/(280*p.x+0.5)),
	# 	floor(5/(280*p.y+0.5))
	# )

func block_complete(x,y):
	emit_signal("block_complete", x,y)

func block_failed(x,y):
	emit_signal("block_failed",x,y)

func invoke_ability(i:int):
	invoke_lock = true
	current_ability = i
	timer_ref.enable(ability_speeds[i], ability_icons[i])

func report_score(score:float):
	invoke_lock = false
	do_ability(current_ability,score)

func do_ability(i:int,score:float):
	if i == 0:
		print("[Game Manager] Slow down")
		var minus = round(5/score)
		print("[Game Manager] Removed " + str(minus) + " blocks from timer")
		block_count -= minus
	elif i == 1:
		print("[Game Manager] Drill")
		var velocity = 2000 * score * player_ref.direction
		var instance = drill_scene.instance()
		print(velocity)
		instance.global_position = player_ref.global_position
		instance.yeet(velocity)
		add_child(instance)
	elif i == 2:
		print("[Game Manager] Jump Boost")
		player_ref.jump_boost(5*score)
	elif i == 3:
		print("[Game Manager] Explode")
		player_ref.explode(100*score)
	elif i == 4:
		print("[Game Manager] Ray Destroy")
		if score > 0.8:
			emit_signal("ray_destroy", global_to_grid_pos(player_ref.global_position))
		else:
			print("Failed Ray")

func game_over(cause):
	print("[Game Over] " + cause)
	invoke_lock = false
	current_ability = 0
	block_count = 0
	block_count_real = 0
	get_tree().change_scene("res://src/scenes/PreStart.tscn")
