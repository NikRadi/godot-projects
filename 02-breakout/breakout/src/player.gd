extends CharacterBody2D


@onready var screen_width := get_viewport_rect().size.x
@onready var sound : AudioStreamPlayer = get_parent().get_node("PaddleHitSound")


func _physics_process(delta: float) -> void:
	const MOVE_SPEED := 300
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("player_move_left", "player_move_right")
	move_and_collide(direction * MOVE_SPEED * delta)


func on_ball_hit():
	sound.play()
