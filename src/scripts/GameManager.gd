extends Node

signal block_complete

func block_complete(x,y):
	emit_signal("block_complete", x,y)

func game_over(cause):
	print("[Game Over] " + cause)
	get_tree().change_scene("res://src/scenes/PreStart.tscn")
