extends Node2D


var score := 0


func _ready() -> void:
	$HUDManager.set_score(0)


func asteroid_destroyed() -> void:
	score += 10
	$HUDManager.set_score(score)
