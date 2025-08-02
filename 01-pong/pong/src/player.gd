extends Area2D


@onready var screen_size_y := get_viewport_rect().size.y
@onready var sound : AudioStreamPlayer = get_parent().get_node("HitPaddleSound")


func _physics_process(delta: float) -> void:
	var direction_y := 0
	if Input.is_action_pressed("player_up"):
		direction_y -= 1
	if Input.is_action_pressed("player_down"):
		direction_y += 1
	
	const MOVE_SPEED := 300
	position.y += direction_y * MOVE_SPEED * delta
	
	const PADDLE_HALF_HEIGHT := 16
	position.y = clamp(position.y, PADDLE_HALF_HEIGHT, screen_size_y - PADDLE_HALF_HEIGHT)


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction.x *= -1
		area.direction.y = randf()
		sound.play()
