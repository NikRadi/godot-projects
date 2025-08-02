extends Area2D


@onready var sound : AudioStreamPlayer = get_parent().get_node("HitWallSound")


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction.y *= -1
		sound.play()
