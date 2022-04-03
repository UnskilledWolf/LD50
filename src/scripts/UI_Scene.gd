extends Control

onready var timers = [
	$AbilityTimer1,
	$AbilityTimer2,
	$AbilityTimer3,
	$AbilityTimer4,
	$AbilityTimer5
]

onready var buttons = [
	$PanelContainer/VBoxContainer/Ability1,
	$PanelContainer/VBoxContainer/Ability2,
	$PanelContainer/VBoxContainer/Ability3,
	$PanelContainer/VBoxContainer/Ability4,
	$PanelContainer/VBoxContainer/Ability5
]

var display_recharge = [
	true,
	true,
	true,
	true,
	true
]

func _ready():
	GameManager.connect("timer_complete", self, "_on_timer_complete")

func _process(_delta):
	for i in range(5):
		if display_recharge[i]:
			buttons[i].text = str(timers[i].time_left).pad_decimals(2) + "s"
	
	# Update speed label
	$PanelContainer/VBoxContainer/SpeedLbl.text = "Speed: " + str(GameManager.block_count)

func invoke_ability(I:int):
	if not GameManager.invoke_lock:
		$Sound.play()
		var i = I-1
		buttons[i].disabled = true
		display_recharge[i] = true
		timers[i].start()
		GameManager.invoke_ability(i)

func restore_ability(I:int):
	var i = I-1
	buttons[i].disabled=false
	display_recharge[i]=false
	buttons[i].text = GameManager.ability_names[i]

func _on_Ability1_pressed():
	invoke_ability(1)

func _on_Ability2_pressed():
	invoke_ability(2)

func _on_Ability3_pressed():
	invoke_ability(3)

func _on_Ability4_pressed():
	invoke_ability(4)

func _on_Ability5_pressed():
	invoke_ability(5)

	
func _on_AbilityTimer1_timeout():
	restore_ability(1)

func _on_AbilityTimer2_timeout():
	restore_ability(2)

func _on_AbilityTimer3_timeout():
	restore_ability(3)

func _on_AbilityTimer4_timeout():
	restore_ability(4)

func _on_AbilityTimer5_timeout():
	restore_ability(5)

func _on_TimerScoreTimer_timeout():
	$TimerScore.text = ""

func _on_timer_complete(score):
	var score_text = ""

	if score > 0.95:
		score_text = "Perfect!"
	elif score > 0.8:
		score_text = "Good"
	elif score > 0.5:
		score_text = "Ok"
	else:
		score_text = "Bad"

	$Sound.play()
	$TimerScore.text = score_text
	$TimerScoreTimer.start()
