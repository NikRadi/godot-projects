extends Node2D

const INVADER_GROUP_NAME = "invaders"
const NUM_COLS := 10
const NUM_ROWS := 4

@onready var crab_invader_scene := preload("res://src/crab_invader.tscn")
@onready var octopus_invader_scene := preload("res://src/octopus_invader.tscn")
@onready var squid_invader_scene := preload("res://src/squid_invader.tscn")

const INVADER_TERRITORY_OFFSET_X := 250
@onready var invader_territory := get_viewport_rect().size - Vector2(INVADER_TERRITORY_OFFSET_X, 500)
@onready var cell_size := invader_territory / Vector2(NUM_COLS, NUM_ROWS)

enum Direction {UP, DOWN, LEFT, RIGHT, COUNT}
var move_direction := Direction.RIGHT
var next_move_direction := Direction.DOWN
var next_column := 1

var invaders : Array[Node2D] = []
var last_time_shot := 0


func _physics_process(delta: float) -> void:
	move_invaders(delta)
	random_invader_shoot()


func _ready() -> void:
	spawn_invaders()


func create_invader(invader_scene: Resource, invader_position: Vector2) -> Node2D:
	const PLAYER_SCALE := 5
	
	var new_invader : Node2D = invader_scene.instantiate()
	new_invader.position = invader_position
	new_invader.scale = Vector2.ONE * PLAYER_SCALE
	
	return new_invader


func move_invaders(delta: float) -> void:
	const MOVE_SPEED := 50 # pixels/sec
	var velocity := Vector2.ZERO
	
	match move_direction:
		Direction.RIGHT:
			velocity.x = MOVE_SPEED
		Direction.LEFT:
			velocity.x = -MOVE_SPEED
		Direction.DOWN:
			velocity.y = MOVE_SPEED
			var next_goal := next_column * cell_size.y
			if position.y > next_goal:
				move_direction = next_move_direction
				next_column += 1
	
	position += velocity * delta


func random_invader_shoot() -> void:
	if invaders.is_empty():
		return
	
	const SHOOT_CHANCE_PERCENT := 1
	var random_int = randi_range(0, 99)
	
	if random_int >= (100 - SHOOT_CHANCE_PERCENT):
		var shooter_idx = randi() % invaders.size()
		var shooter := invaders[shooter_idx]
		
		if shooter:
			shooter.shoot()
		else:
			invaders.remove_at(shooter_idx)


func spawn_invaders() -> void:
	const BASE_POSITION := Vector2(INVADER_TERRITORY_OFFSET_X, 0) * 0.5
	var row_invader_type = [squid_invader_scene, crab_invader_scene, crab_invader_scene, octopus_invader_scene]
	var cell_center_offset := cell_size * 0.5
	
	for col in NUM_COLS:
		for row in NUM_ROWS:
			var invader_scene = row_invader_type[row]
			var grid_position := Vector2(col, row) * cell_size
			var invader_position := BASE_POSITION + cell_center_offset + grid_position
			
			var new_invader := create_invader(invader_scene, invader_position)
			new_invader.add_to_group(INVADER_GROUP_NAME)
			add_child(new_invader)
			invaders.append(new_invader)


func _on_invader_walls_body_entered(body: Node2D) -> void:
	if body.is_in_group(INVADER_GROUP_NAME):
		if move_direction == Direction.LEFT:
			next_move_direction = Direction.RIGHT
		elif move_direction == Direction.RIGHT:
			next_move_direction = Direction.LEFT
		
		move_direction = Direction.DOWN
