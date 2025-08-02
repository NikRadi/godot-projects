extends Area2D


@onready var ball : Area2D = get_parent().get_node("Ball")
@onready var screen_size_y := get_viewport_rect().size.y
@onready var sound : AudioStreamPlayer = get_parent().get_node("HitPaddleSound")


func _physics_process(_delta: float) -> void:
	global_position.y = ball.global_position.y
	
	const PADDLE_HALF_HEIGHT := 16
	global_position.y = clamp(global_position.y, PADDLE_HALF_HEIGHT, screen_size_y - PADDLE_HALF_HEIGHT)


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction.x *= -1
		area.direction.y = randf()
		sound.play()
