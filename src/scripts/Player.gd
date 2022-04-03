extends KinematicBody2D

export (float) var speed = 80
export (float) var jump_velocity_normal = 300
export (float) var jump_velocity_boost = 700
export (float) var gravity = 600
export (float) var friction = 0.21

var v = Vector2.ZERO # Current Velocity
var direction = -1
var jump_velocity = 300

func jump_boost(time:float):
	jump_velocity = jump_velocity_boost
	$JumpBoostTimer.start(time)
	$JumpBoostParticles.emitting = true

func explode(radius:float):
	$Bomb/Circle.shape.radius = radius
	$ExplosionParticles.emission_sphere_radius = radius
	$ExplosionTimer.start()

func get_input():
	# Left and Right
	if Input.is_action_pressed("left"):
		$Sprite.flip_h = false
		direction = -1
		return -speed
	elif Input.is_action_pressed("right"):
		$Sprite.flip_h = true
		direction = 1
		return speed
	else:
		return 0

func _ready():
	GameManager.player_ref=self
	jump_velocity = jump_velocity_normal

func _physics_process(delta):
	v.x += get_input() # User Input
	v.y += gravity * delta # Gravity

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		v.y = -jump_velocity

	# print(v)
	v = move_and_slide(v, Vector2.UP)

	# Friction
	v.x = lerp(v.x,0,friction)

func _on_JumpBoostTimer_timeout():
	jump_velocity = jump_velocity_normal
	$JumpBoostParticles.emitting = false

func _on_ExplosionTimer_timeout():
	$ExplosionParticles.emitting = true
	for body in $Bomb.get_overlapping_bodies():
		body.set_block_scale(Vector2.ZERO, 0.1, false)
