extends Control

onready var rt = $CenterContainer/Panel/VBoxContainer/RichTextLabel

func _ready():
	rt.text = "Score: " + str(GameManager.block_count_real)

	# Clear Stats
	GameManager.block_count_real = 0


func _on_StartButton_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
