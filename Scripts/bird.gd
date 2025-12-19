extends RigidBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D

signal died
signal scored

func jump() -> void:
	print_debug("Jump")
	apply_central_impulse(Vector2(0, -600))


func _input(event):
	if event.is_action_pressed("jump"):
		jump()

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node):
	print_debug("touch")
	if body.is_in_group("pipes"):
		emit_signal("died")
		print_debug("Game Over!")

	if body.is_in_group("score"):
		emit_signal("scored")
		print_debug("Score +1")
