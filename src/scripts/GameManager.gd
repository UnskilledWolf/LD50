extends Node

signal block_complete

func block_complete(x,y):
	emit_signal("block_complete", x,y)