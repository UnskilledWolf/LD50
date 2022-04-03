class_name Block
extends StaticBody2D

onready var timer = $Timer
onready var collider = $CollisionShape2D
onready var area = $Death

# The Block's index in the array
var x = 0;
var y = 0;

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

	# Block failed to grow before being reset
	if target_collision == true and collision_on_finish == false:
		GameManager.block_failed(x,y)


func cancel():
	is_changing = false
	scale = start_scale

func _process(_delta):
	if is_changing:
		scale = lerp(target_scale, start_scale, timer.time_left/timer.wait_time)

func _on_Timer_timeout():
	if is_changing:
		print("["+name+"] Timeout")
		is_changing = false
		scale = target_scale
		collider.disabled = !target_collision
		area.monitoring = target_collision

		if target_collision  == true:
			GameManager.block_complete(x,y)

func _on_Death_body_entered(body):
	print(body.name)
	GameManager.game_over("Entered Block!")
