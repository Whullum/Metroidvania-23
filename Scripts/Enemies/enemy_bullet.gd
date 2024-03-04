extends CharacterBody2D

@export var bullet_speed: float = 1.5

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
	pass

func _set_bullet_velocity(target_position: Vector2, current_position: Vector2):
	velocity = (target_position - current_position) * bullet_speed
	pass

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.

func _on_area_2d_area_entered(area):
	queue_free()

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body.name == "Player":
		queue_free()
