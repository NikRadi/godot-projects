extends Node


var score := 0


func _ready() -> void:
	update_score()


func update_score() -> void:
	$ScoreLabel.text = "Score: " + str(score)
