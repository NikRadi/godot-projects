extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction.x *= -1
