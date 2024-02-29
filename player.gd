extends CharacterBody2D

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking: bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$PlayerSprite.play("jump")

	if is_on_floor():
		$DigHitbox/GroundPoundCollisionShape2D.disabled = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle melee attacks
	# !! WILL NEED TO CHANGE WITH KEYFRAMES ONCE ANIMATIONS GET IN !!
	if Input.is_action_just_pressed("melee_attack") and is_on_floor():
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
		$DigHitbox/GroundPoundCollisionShape2D.disabled = false
	
	# Ground Pound behavior psudocode
	# func _on_groundpound_body_collide_with_enemy():
	# 	apply a force in the opposide vector direction of player to bounce them off
	# 	weight the force more in the up (positive y) direction
	# 	perhaps add a damage multiplier for every enemy hit while ground pounding
	
	# Handle moving through one way platforms
	# Moves the character position through the platform hitbox
	if Input.is_action_pressed("down") and is_on_floor():
		position.y += 2
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if !is_attacking:
		if direction:
			$PlayerSprite.play("run")
			velocity.x = direction * SPEED
			if direction == -1:
				$PlayerSprite.flip_h = true
			else:
				$PlayerSprite.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$PlayerSprite.play("idle")
		move_and_slide()
		
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and direction != 0:
		$WateringCanHitbox.scale.x = sign(velocity.x)
		$MeleeHitbox.scale.x = sign(velocity.x)
		$DigHitbox.scale.x = sign(velocity.x)

func _on_melee_hitbox_timer_timeout():
	$MeleeHitbox/CollisionShape2D.disabled = true
	is_attacking = false

func _on_watering_can_timer_timeout():
	$WateringCanHitbox/CollisionShape2D.disabled = true
	is_attacking = false

func _on_dig_hitbox_timer_timeout():
	$DigHitbox/CollisionShape2D.disabled = true
	is_attacking = false
