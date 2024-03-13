extends EnemyBase

@export var maximum_patrol_distance: float = 10
@export var is_in_air: bool = false
@export var knockback_magnituge: float = 100.0

var original_position: Vector2
var player_position: Vector2
var too_far_from_original: bool = false
var player

enum ENEMY_ORDERS {PATROL, CHASE_PLAYER, RETURN_TO_ORIGINAL_POSITION, DEATH}
@export var current_orders: ENEMY_ORDERS

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = global_position
	current_orders = ENEMY_ORDERS.PATROL
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		pass
	
	if ($IFrameTimer.is_stopped()):
		match current_orders:
			ENEMY_ORDERS.PATROL:
				pass
			ENEMY_ORDERS.CHASE_PLAYER:
				#print_debug("Chasing_Player")
				player_position = player.position
				if !is_in_air:
					_move_to(player_position, delta)
				else:
					_flying_move_to(player_position, delta)
				pass
			ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION:
				#print_debug("Returning to original position")
				_return_to_original_position(delta)
				if (original_position - global_position).length() < 10:
					current_orders = ENEMY_ORDERS.PATROL
					pass
				pass
			ENEMY_ORDERS.DEATH:
				pass
			_:
				pass
			
	if (original_position - global_position).length() > maximum_patrol_distance:
		too_far_from_original = true
		current_orders = ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION
		pass
	else:
		too_far_from_original = false
		
	if sign(velocity.x) < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func _on_detection_area_area_entered(area):
	#print_debug(area.name)
	if area.name == "PlayerHitbox" and !too_far_from_original and health > 0:
		#print_debug("collision is player")
		player_position = area.global_position
		current_orders = ENEMY_ORDERS.CHASE_PLAYER
		$AnimatedSprite2D.play("chase")
		pass

func _move_to(target: Vector2, delta):
	var desired_velocity = _calculate_desired_velocity(target)
	velocity = Vector2(desired_velocity.x, 0)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var bounce_velocity: Vector2
		velocity = velocity.bounce(collision.get_normal()) * knockback_magnituge
	pass
	
func _flying_move_to(target: Vector2, delta):
	var desired_velocity = _calculate_desired_velocity(target)
	velocity = desired_velocity
	
	# Handle collisions so player doesn't get stuck connected to enemy
	var collision = move_and_collide(velocity * delta)
	if collision:
		var bounce_velocity: Vector2
		velocity = velocity.bounce(collision.get_normal()) * knockback_magnituge
	pass
	
func _calculate_desired_velocity(target: Vector2):
	var direction: Vector2 = (target - global_position).normalized()
	var desired_velocity:Vector2 = direction * speed
	return desired_velocity

func _return_to_original_position(delta):
	_move_to(original_position, delta)
	pass

func _on_detection_area_area_exited(area):
	if area.name == "PlayerHitbox" and health > 0:
		current_orders = ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION
		$AnimatedSprite2D.play("idle")
		pass
	pass # Replace with function body

func _on_enemy_damage_hitbox_area_entered(area):
	if area.name == "MeleeHitbox" or area.name == "GroundPoundHitbox":
		velocity += -velocity * knockback_magnituge
		move_and_slide()
		
		$IFrameTimer.start()
		
		velocity = Vector2(0, 0)
		move_and_slide()
		
		_patrol_take_damage()
	pass # Replace with function body.

func _patrol_take_damage():
	health -= 1
	
	if health <= 0:
		GlobalPlayerStats.colleceted_water += 10
		get_tree().current_scene._on_water_number_updated()
		
		current_orders = ENEMY_ORDERS.DEATH
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	else:
		$AnimatedSprite2D.play("damaged")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("chase")
	pass
