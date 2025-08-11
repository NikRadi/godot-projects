extends CharacterBody2D


# Rotation
var rotation_speed := 180 # degrees/second

# Movement and acceleration
var acceleration :=  10
var speed        :=   0 # pixels/second
var max_speed    := 300 # pixels/second

# Shooting
var shots_per_second        := 2
var seconds_since_last_shot := 0.0


func _physics_process(delta: float) -> void:
	# Rotation
	var input_axis := Input.get_axis("player_rotate_left", "player_rotate_right")
	var radians := deg_to_rad(rotation_speed) * input_axis * delta
	rotate(radians)
	
	# Movement, acceleration, and collision
	if Input.is_action_pressed("player_accelerate"):
		var direction := Vector2.UP.rotated(rotation)
		velocity += direction * acceleration
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration / 2)
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("destroy"):
			collision.get_collider().destroy()
		
		if $StrongShieldSprite2D.visible:
			$StrongShieldSprite2D.hide()
			$WeakShieldSprite2D.show()
		elif $WeakShieldSprite2D.visible:
			$WeakShieldSprite2D.hide()
		else:
			queue_free()
	
	# Shooting
	seconds_since_last_shot += delta
	var can_shoot := seconds_since_last_shot >= (1.0 / shots_per_second)
	if can_shoot and Input.is_action_pressed("player_shoot"):
		seconds_since_last_shot = 0.0
		var bullet_scale := Vector2.ONE * 3
		var bullet = Bullet.spawn($PrimaryGun.global_position, rotation, bullet_scale)
		get_tree().root.add_child(bullet)
		$ShootSound.play()
	
	# Animation
	var is_left_thruster_active := input_axis > 0 or Input.is_action_pressed("player_accelerate")
	if is_left_thruster_active:
		$LeftThrusterAnimation.show()
	else:
		$LeftThrusterAnimation.hide()
		
	var is_right_thruster_active := input_axis < 0 or Input.is_action_pressed("player_accelerate")
	if is_right_thruster_active:
		$RightThrusterAnimation.show()
	else:
		$RightThrusterAnimation.hide()
