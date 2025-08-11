extends Node2D


var asteroids : Array[CharacterBody2D] = []
const MAX_ASTEROIDS = 10


func _physics_process(_delta: float) -> void:
	var chance = max(0.0, 1.0 - (float(asteroids.size()) / MAX_ASTEROIDS))
	if randf() < chance:
		spawn_asteroid()


func spawn_asteroid() -> void:
	var asteroid_position := random_offscreen_position()
	var asteroid_direction := random_offscreen_position().normalized()
	
	var asteroid := Asteroid.spawn(asteroid_position, asteroid_direction)
	asteroid.asteroid_destroyed.connect(_on_asteroid_destroyed)
	asteroids.append(asteroid)
	add_child(asteroid)


func random_offscreen_position() -> Vector2:
	var viewport_size := get_viewport_rect().size
	var side = randi() % 4
	match side:
		0: # Left
			return Vector2(-10, randf() * viewport_size.y)
		1: # Right
			return Vector2(viewport_size.x + 10, randf() * viewport_size.y)
		2: # Top
			return Vector2(randf() * viewport_size.x, -10)
		3: # Bottom
			return Vector2(randf() * viewport_size.x, viewport_size.y + 10)
	
	assert(false, "random_offscreen_position: invalid side value: " + str(side))
	return Vector2.ZERO  # Fallback (should never happen)


func _on_asteroid_destroyed(asteroid: Asteroid, left_screen: bool) -> void:
	asteroids.erase(asteroid)
	
	if not left_screen:
		get_parent().asteroid_destroyed()
