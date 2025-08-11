class_name Bullet extends CharacterBody2D


const MOVE_SPEED := 500


static func spawn(spawn_pos: Vector2, spawn_rot: float, spawn_scale: Vector2) -> CharacterBody2D:
	var bullet := preload("res://src/bullet.tscn").instantiate()
	bullet.position = spawn_pos
	bullet.rotation = spawn_rot
	bullet.scale = spawn_scale
	return bullet


func _physics_process(delta: float) -> void:
	velocity = Vector2.UP.rotated(rotation) * MOVE_SPEED
	var collision := move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("destroy"):
			collision.get_collider().destroy()
		
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
