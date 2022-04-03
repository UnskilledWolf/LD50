extends Sprite

export var speed = 20
export var y_limit = -37.718

onready var slider = $TimerSlider
onready var icon = $Icon

var direction = 1
var enabled = false

# NOTE this whole thing is turned 90deg so x and y are switched!

func enable(speeeeed: float, ticon: Texture):
	enabled = true
	speed = speeeeed
	visible = true
	slider.visible = true
	icon.texture = ticon
	icon.visible = true

func disable():
	enabled = false
	visible = false
	slider.visible = false
	icon.visible = false

func _ready():
	disable()
	GameManager.timer_ref = self

func _process(delta):
	if enabled:
		# Get Key
		if Input.is_action_just_pressed("timer"):
			var score = 1-abs(slider.position.x/y_limit)
			print("[Timer] Score: " + str(score))
			GameManager.report_score(score)
			
			disable()
		
		# Update Position
		slider.position.x += speed * delta * direction
		
		if slider.position.x < y_limit or slider.position.x > -y_limit:
			direction *= -1
