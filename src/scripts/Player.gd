extends KinematicBody2D

export (float) var speed = 80
export (float) var jump_velocity = 300
export (float) var gravity = 600
export (float) var friction = 0.21

# onready var drillArea = $Drill

var v = Vector2.ZERO # Current Velocity

func get_input():
	# Left and Right
	if Input.is_action_pressed("left"):
		$Sprite.flip_h = false
		return -speed
	elif Input.is_action_pressed("right"):
		$Sprite.flip_h = true
		return speed
	else:
		return 0

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

# func _process(_delta):
# 	var mouse_pos = get_global_mouse_position();
# 	if global_position.distance_to(mouse_pos) < 500:
# 		drillArea.global_position = mouse_pos	
# 		drillArea.look_at(self.position)
# 		drillArea.rotation_degrees+=210
