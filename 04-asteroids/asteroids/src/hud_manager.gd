extends Node


var total_delta := 0.0


func _process(delta: float) -> void:
	total_delta += delta
	
	var seconds_passed = int(floor(total_delta))
	$TimeLabel.text = "Time: " + str(seconds_passed) + "s"


func set_score(score: int) -> void:
	$ScoreLabel.text = "Score: " + str(score)
