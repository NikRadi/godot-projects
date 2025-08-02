extends Area2D


# Must be global so other scripts can access and modify it.
var direction = Vector2.LEFT


func _physics_process(delta: float) -> void:
	const MOVE_SPEED := 300
	position += MOVE_SPEED * direction * delta
