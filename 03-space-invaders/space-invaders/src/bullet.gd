extends CharacterBody2D


var direction : Vector2
var speed : int


func _ready() -> void:
	if get_node("CPUParticles2D"):
		$CPUParticles2D.scale_amount_min = scale.x - 1
		$CPUParticles2D.scale_amount_max = scale.x + 1


func _physics_process(delta: float) -> void:
	var motion := direction * speed * delta
	var collision = move_and_collide(motion)
	
	if collision:
		if collision.get_collider().has_method("on_bullet_hit"):
			collision.get_collider().on_bullet_hit()
		
		queue_free()


func on_bullet_hit() -> void:
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	
	if get_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(1).timeout
	
	queue_free()
