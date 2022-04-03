extends Sprite

export var speed = 20
export var y_limit = -37.718

onready var slider = $TimerSlider
onready var icon = $Icon

var direction = 1
var enabled = false
var rng = RandomNumberGenerator.new()

# NOTE this whole thing is turned 90deg so x and y are switched!

func enable(speeeeed: float, frticon: Texture):
	enabled = true
	speed = speeeeed
	icon.texture = frticon

	slider.position.x = rng.randf_range(y_limit+1, -y_limit-1)

	$AnimationPlayer.play("animateIn")

func disable():
	enabled = false
	$AnimationPlayer.play("animateOut")

func _ready():
	disable()
	GameManager.timer_ref = self
	rng.randomize()

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
