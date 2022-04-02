extends Node

signal block_complete

var ability_names = [
	"Slow Blocks",
	"Pickaxe",
	"Jump Boost",
	"Bomb",
	"Ray"
]

var ability_speeds = [
	20,
	30,
	40,
	50,
	60
]

var timer_ref
var invoke_lock = false
var current_ability = 0
var block_count = 0 # Used for timing
var block_count_real = 0 # Used for score

func block_complete(x,y):
	emit_signal("block_complete", x,y)

func invoke_ability(i:int):
	invoke_lock = true
	current_ability = i
	timer_ref.enable(ability_speeds[i])

func report_score(score:float):
	invoke_lock = false
	do_ability(current_ability,score)

func do_ability(i:int,score:float):
	if i == 0:
		var minus = round(5/score)
		print("[Game Manager] Removed " + str(minus) + " blocks from timer")
		block_count -= minus
	elif i == 1:
		pass
	elif i == 2:
		pass
	elif i == 3:
		pass
	elif i == 4:
		pass

func game_over(cause):
	print("[Game Over] " + cause)
	get_tree().change_scene("res://src/scenes/PreStart.tscn")
