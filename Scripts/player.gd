extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -350.0
@export var jump_velocity_double: float = -300.0
@export var jump_velocity_from_climb: float = -350.0
@export var climb_velocity: float = -5.0
@export var bounce_magnitude: float = -2.0
@export var bounce_height: float = 300.0
@export var knockback_magnitude: float = -300
@export var velocity_x_clamp: float = 300.0
@export var velocity_y_clamp: float = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking: bool = false
var can_climb = false
var is_climbing = false
var has_double_jump = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and !is_climbing:
		velocity.y += gravity * delta
		$PlayerSprite.play("jump")

	if is_on_floor() and !$GroundPoundHitbox/GroundPoundCollisionShape2D.disabled:
		$GroundPoundHitbox/GroundPoundCollisionShape2D.disabled = true
		
	if is_on_floor() or is_climbing:
		has_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_climbing):
		if is_climbing:
			velocity.y = jump_velocity_from_climb
		if is_on_floor():
			velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		if has_double_jump:
			velocity.y = jump_velocity_double
			has_double_jump = false
			pass
		pass
	
	if Input.is_action_just_released("jump"):
		velocity.y = velocity.y / 2
		pass
		
	# Handle melee attacks
	# !! WILL NEED TO CHANGE WITH KEYFRAMES ONCE ANIMATIONS GET IN !!
	if Input.is_action_just_pressed("melee_attack"): #and is_on_floor():
		$MeleeHitbox/CollisionShape2D.disabled = false
		is_attacking = true
		$MeleeHitbox/MeleeHitboxTimer.start()
	
	# Handle watering can action
	if Input.is_action_just_pressed("watering_can") and is_on_floor():
		$WateringCanHitbox/CollisionShape2D.disabled = false
		is_attacking = true
		$WateringCanHitbox/WateringCanTimer.start()
	
	# Handle dig action
	if Input.is_action_just_pressed("dig_action") and is_on_floor():
		$DigHitbox/CollisionShape2D.disabled = false
		is_attacking = true
		$DigHitbox/DigHitboxTimer.start()
		
	# Handle ground pound action
	if Input.is_action_just_pressed("dig_action") and !is_on_floor():
		$GroundPoundHitbox/GroundPoundCollisionShape2D.disabled = false
	# 	perhaps add a damage multiplier for every enemy hit while ground pounding
	
	# Handle moving through one way platforms
	# Moves the character position through the platform hitbox
	if Input.is_action_pressed("down") and is_on_floor():
		position.y += 2
		
	# Handle climbing behavior
	if (Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")) and can_climb:
		self.velocity.y = 0
		is_climbing = true
		
	if Input.is_action_pressed("up") and can_climb:
		self.position.y += climb_velocity
		
	if Input.is_action_pressed("down") and can_climb:
		self.position.y -= climb_velocity
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if !is_attacking:
		if direction:
			$PlayerSprite.play("run")
			velocity.x = direction * speed
			if direction == -1:
				$PlayerSprite.flip_h = true
			else:
				$PlayerSprite.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			$PlayerSprite.play("idle")
		
		move_and_slide()
	pass
	
	if is_attacking and !is_on_floor():
		move_and_slide()
	
	
		
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and direction != 0:
		$WateringCanHitbox.scale.x = sign(velocity.x)
		$MeleeHitbox.scale.x = sign(velocity.x)
		$DigHitbox.scale.x = sign(velocity.x)
		
	if abs(velocity.x) > velocity_x_clamp:
		velocity.x = velocity_x_clamp * sign(velocity.x)
		
	if abs(velocity.y) > velocity_y_clamp:
		velocity.y = velocity_y_clamp * sign(velocity.y)

func _on_melee_hitbox_timer_timeout():
	$MeleeHitbox/CollisionShape2D.disabled = true
	is_attacking = false

func _on_watering_can_timer_timeout():
	$WateringCanHitbox/CollisionShape2D.disabled = true
	is_attacking = false

func _on_dig_hitbox_timer_timeout():
	$DigHitbox/CollisionShape2D.disabled = true
	is_attacking = false

func _on_interactable_hitbox_area_entered(area):
	if area.name == "ClimbableVine":
		can_climb = true

func _on_interactable_hitbox_area_exited(area):
	if area.name == "ClimbableVine":
		can_climb = false
		is_climbing = false

# Handle Pogo behavior with ground pound attacks
func _on_ground_pound_hitbox_area_entered(area):
	var bounce_velocity: Vector2
	bounce_velocity = global_position + area.global_position
	bounce_velocity.normalized()
	velocity += Vector2(bounce_velocity.x * sign(velocity.x), bounce_height) * bounce_magnitude
	move_and_slide()
	pass # Replace with function body.

func _on_player_hitbox_area_entered(area):
	print_debug("colliding with: " + area.name)
	velocity = -global_position.direction_to(area.position) * knockback_magnitude
	move_and_slide()
	pass # Replace with function body.
