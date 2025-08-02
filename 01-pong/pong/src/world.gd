extends Node2D


@onready var screen_size := get_viewport_rect().size
var ai_score := 0
var player_score := 0


func _ready() -> void:
	update_score_texts()


func _on_ai_goal_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		player_score += 1
		update_score_texts()
		reset_game()


func _on_player_goal_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		ai_score += 1
		update_score_texts()
		reset_game()


func update_score_texts() -> void:
	$Score/AIScore.text = str(ai_score)
	$Score/PlayerScore.text = str(player_score)


func reset_game() -> void:
	var ball : Node2D = get_node("Ball")
	ball.position = screen_size / 2
	ball.direction = Vector2.ZERO
	await get_tree().create_timer(1).timeout
	ball.direction = Vector2.LEFT
