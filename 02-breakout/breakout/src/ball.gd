extends CharacterBody2D


signal hit_brick


@onready var screen_size := get_viewport_rect().size


func _ready() -> void:
	start()


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)
	if !collision:
		return
	
	self.velocity = self.velocity.bounce(collision.get_normal())
	if collision.get_collider().has_method("on_ball_hit"):
		collision.get_collider().on_ball_hit()
		hit_brick.emit()


func reset() -> void:
	self.position = Vector2(400, 500)
	self.velocity = Vector2.ZERO


func start() -> void:
	const MOVE_SPEED := 300
	self.velocity = Vector2(randf_range(-1, 1), 1) * MOVE_SPEED
	
