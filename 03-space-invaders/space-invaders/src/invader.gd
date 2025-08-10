extends Node2D


var bullet_scene : PackedScene = preload("res://src/bullet.tscn")


func _ready() -> void:
	if get_node("CPUParticles2D"):
		$CPUParticles2D.scale_amount_min = scale.x - 1
		$CPUParticles2D.scale_amount_max = scale.x + 1


func on_bullet_hit() -> void:
	var hud := get_parent().get_parent().get_node("HUD")
	hud.score += 10
	hud.update_score()
	
	$AnimatedSprite2D.hide()
	$CollisionShape2D.disabled = true
	
	if get_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(1).timeout
	
	queue_free()


func shoot() -> void:
	const PLAYER_COLLISION_MASK := 2
	
	var new_bullet : CharacterBody2D = bullet_scene.instantiate()
	new_bullet.collision_mask = PLAYER_COLLISION_MASK
	new_bullet.direction = Vector2.DOWN
	new_bullet.global_position = global_position
	new_bullet.scale = Vector2(3, 3)
	new_bullet.speed = 200
	get_parent().get_parent().add_child(new_bullet)
