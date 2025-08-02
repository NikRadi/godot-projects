extends StaticBody2D


@onready var sound : AudioStreamPlayer = get_parent().get_node("BrickHitSound")


func on_ball_hit() -> void:
	sound.play()
	queue_free()
