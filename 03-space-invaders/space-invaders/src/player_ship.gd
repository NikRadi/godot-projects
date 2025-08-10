extends CharacterBody2D


var bullet_scene : PackedScene = preload("res://src/bullet.tscn")


func _ready() -> void:
	if get_node("CPUParticles2D"):
		$CPUParticles2D.scale_amount_min = scale.x - 1
		$CPUParticles2D.scale_amount_max = scale.x + 1


func _physics_process(delta: float) -> void:
	const MOVE_SPEED := 500
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("player_move_left", "player_move_right")
	move_and_collide(direction * MOVE_SPEED * delta)


func _on_shoot_bullet_timer_timeout() -> void:
	var new_bullet : CharacterBody2D = bullet_scene.instantiate()
	new_bullet.direction = Vector2.UP
	new_bullet.global_position = $PrimaryGun.global_position
	new_bullet.scale = Vector2(3, 3)
	new_bullet.speed = 400
	get_parent().add_child(new_bullet)


func on_bullet_hit() -> void:
	$CollisionShape2D.disabled = true
	$Sprite2D.hide()
	
	if get_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(1).timeout
	
	queue_free()
