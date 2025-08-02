extends Node2D


@onready var brick_scene := preload("res://src/brick.tscn")
@onready var screen_size := get_viewport_rect().size
@onready var saved_high_score := SaverLoader.load_high_score()
var score := 0
var high_score := 0
var bricks : Array[Node] = []


func _ready() -> void:
	create_level()
	high_score = saved_high_score
	$HUD.update_score(score)
	$HUD.update_high_score(high_score)


func create_level() -> void:
	const NUM_COLUMNS := 16
	const NUM_ROWS := 8
	const COLORS := [Color.LIGHT_SKY_BLUE, Color.GREEN_YELLOW, Color.LIGHT_YELLOW, Color.CORAL]
	
	var column_width := screen_size.x / NUM_COLUMNS
	var row_height := (screen_size.y / NUM_ROWS) / 2
	
	# Limit where brick spawn area to add distance to player.
	row_height *= 0.75
	
	for column in NUM_COLUMNS:
		for row in NUM_ROWS:
			var new_brick := brick_scene.instantiate()
			
			# Set position
			var offset = Vector2(column_width, row_height) / 2
			new_brick.position = Vector2(column_width * column, row_height * row) + offset
			
			# Set color
			new_brick.get_node("Sprite2D").modulate = COLORS[row % COLORS.size()]
			
			add_child(new_brick)
			bricks.append(new_brick)


func _on_ball_hit_brick() -> void:
	score += 1
	$HUD.update_score(score)
	if score >= high_score:
		high_score = score
		$HUD.update_high_score(score)


func _on_game_over_area_body_entered(body: Node2D) -> void:
	if body.name != "Ball":
		return
	
	score = 0
	if high_score > saved_high_score:
		SaverLoader.save_high_score(high_score)
		saved_high_score = high_score
	
	$HUD.show_game_over()
	$Ball.reset()
	await get_tree().create_timer(3).timeout
	$HUD.update_score(score)
	$Ball.start()
	
	for brick in bricks:
		if brick:
			brick.queue_free()
	
	create_level()
