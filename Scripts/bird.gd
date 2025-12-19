extends RigidBody2D

func jump() -> void:
	print_debug("Jump")
	apply_central_impulse(Vector2(0, -600))


func _input(event):
	if event.is_action_pressed("jump"):
		jump()