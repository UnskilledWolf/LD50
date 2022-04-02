class_name Block
extends StaticBody2D

onready var timer = $Timer
onready var collider = $CollisionShape2D

var target_scale = Vector2.ZERO;
var start_scale = Vector2.ZERO;
var target_collision = false;
var is_changing = false;

func set_block_scale(scale_to: Vector2, speed: float, collision_on_finish: bool):
	print("["+name+"] Going to scale " + str(scale_to))

	target_scale = scale_to
	start_scale = scale
	target_collision = collision_on_finish

	is_changing = true
	timer.start(speed)

func _process(_delta):
	if is_changing:
		scale = lerp(target_scale, start_scale, timer.time_left/timer.wait_time)

func _on_Timer_timeout():
	print("["+name+"] Timeout")
	is_changing = false
	scale = target_scale
	collider.disabled = !target_collision
