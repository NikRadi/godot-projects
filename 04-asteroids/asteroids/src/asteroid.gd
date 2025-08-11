class_name Asteroid extends CharacterBody2D

signal asteroid_destroyed(asteroid: Asteroid, left_screen: bool)

var direction: Vector2
var move_speed: int
var rotation_speed: int


static func spawn(spawn_pos: Vector2, spawn_dir: Vector2) -> CharacterBody2D:
	var small_asteroid_scene := preload("res://src/asteroid_small.tscn")
	var big_asteroid_scene := preload("res://src/asteroid_big.tscn")
	var asteroid_scene := small_asteroid_scene if randi() % 2 == 0 else big_asteroid_scene
	
	var asteroid := asteroid_scene.instantiate()
	asteroid.position = spawn_pos
	asteroid.direction = spawn_dir
	asteroid.scale = Vector2.ONE * randf_range(2, 4)
	asteroid.rotation_speed = randi_range(-2, 2)
	asteroid.move_speed = randi_range(20, 100)
	return asteroid


func _physics_process(delta: float) -> void:
	velocity = direction * move_speed
	rotation += rotation_speed * delta
	var collision := move_and_collide(velocity * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())


func destroy() -> void:
	asteroid_destroyed.emit(self, false)
	
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	direction = Vector2.ZERO
	move_speed = 0
	rotation_speed = 0
	
	$ExplosionSound.play()
	$ExplosionAnimation.visible = true
	$ExplosionAnimation.play()
	await $ExplosionAnimation.animation_finished
	await $ExplosionSound.finished
	queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	asteroid_destroyed.emit(self, true)
	queue_free()
