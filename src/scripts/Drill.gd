extends KinematicBody2D

export (float) var speed = 80
export (float) var gravity = 600
export (float) var friction = 0.21

var v = Vector2.ZERO

func yeet(velocity:float):
	v.x += velocity

func _physics_process(delta):
	v.y += gravity * delta # Gravity

	v = move_and_slide(v, Vector2.UP)

	# Friction
	v.x = lerp(v.x,0,friction)

func _on_Despawn_timeout():
	queue_free()

func _on_Area2D_body_entered(body:Node):
	body.set_block_scale(Vector2.ZERO, 0.1, false)
	queue_free()
