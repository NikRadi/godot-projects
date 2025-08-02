extends CanvasLayer


func update_score(score: int) -> void:
	$ScoreLabel.text = "Score: " + str(score)


func update_high_score(high_score: int) -> void:
	$HighScoreLabel.text = "High Score: " + str(high_score)


func show_game_over() -> void:
	$MessageLabel.text = "Game Over"
	$MessageLabel.show()
	$MessageLabelTimer.start()


func _on_message_label_timer_timeout() -> void:
	$MessageLabel.hide()
