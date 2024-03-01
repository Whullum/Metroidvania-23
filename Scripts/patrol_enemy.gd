extends EnemyBase

@export var maximum_patrol_distance: float = 30

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var original_position: Vector2
var player_position: Vector2
var too_far_from_original: bool = false

enum ENEMY_ORDERS {PATROL, CHASE_PLAYER, RETURN_TO_ORIGINAL_POSITION}
var current_orders: ENEMY_ORDERS

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = global_position
	current_orders = ENEMY_ORDERS.PATROL
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		pass
		
	match current_orders:
		ENEMY_ORDERS.PATROL:
			pass
		ENEMY_ORDERS.CHASE_PLAYER:
			#print_debug("Chasing_Player")
			_move_to(player_position)
			pass
		ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION:
			#print_debug("Returning to original position")
			_return_to_original_position()
			if (original_position - global_position).length() < 10:
				current_orders = ENEMY_ORDERS.PATROL
				pass
			pass
		_:
			pass
			
	if (original_position - global_position).length() > maximum_patrol_distance:
		too_far_from_original = true
		current_orders = ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION
		pass
	else:
		too_far_from_original = false

func _on_detection_area_area_entered(area):
	#print_debug(area.name)
	if area.name == "PlayerHitbox" and !too_far_from_original:
		#print_debug("collision is player")
		player_position = area.global_position
		current_orders = ENEMY_ORDERS.CHASE_PLAYER
		pass
	else:
		#print_debug("Collision is not player")
		pass # Replace with function body.

func _move_to(target: Vector2):
	var direction: Vector2 = (target - global_position).normalized()
	var desired_velocity:Vector2 = direction * speed
	desired_velocity = Vector2(desired_velocity.x, 0)
	velocity = desired_velocity
	move_and_slide()
	pass

func _return_to_original_position():
	_move_to(original_position)
	pass

func _on_detection_area_area_exited(area):
	if area.name == "PlayerHitbox":
		current_orders = ENEMY_ORDERS.RETURN_TO_ORIGINAL_POSITION
		pass
	pass # Replace with function body

func _on_enemy_damage_hitbox_area_entered(area):
	if area.name == "MeleeHitbox":
		_take_damage()
	pass # Replace with function body.
