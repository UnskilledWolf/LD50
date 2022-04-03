extends Control

onready var rt = $CenterContainer/Panel/VBoxContainer/RichTextLabel

func _ready():
	rt.text = "Score: " + str(GameManager.block_count_real) + "\nHigh Score: " + str(GameManager.high_score)

	# Clear Stats
	GameManager.block_count_real = 0


func _on_StartButton_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
