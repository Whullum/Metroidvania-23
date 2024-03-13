extends EnemyBase

@export var bullet_object: PackedScene = preload("res://Scenes/Prefabs/Enemies/enemy_bullet.tscn")

var is_player_within_range: bool = false
var player_position: Vector2
var player

func _ready():
	$Timer.start()
	$Timer.set_paused(true)
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play("idle")
	pass

func _physics_process(delta):
	if is_player_within_range:
		player_position = player.position
		_angle_towards_player()
	pass

func _shoot_player():
	var spawned_bullet = bullet_object.instantiate()
	spawned_bullet.position = global_position
	spawned_bullet._set_bullet_velocity(player_position, global_position)
	get_parent().add_child(spawned_bullet)
	$AnimatedSprite2D.play("shooting")
	pass

func _angle_towards_player():
	if position.direction_to(player_position).length() >= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	pass

func _on_detection_area_area_entered(area):
	if area.name == "PlayerHitbox" and health > 0:
		#print_debug("Player within range")
		player_position = area.global_position
		is_player_within_range = true
		$Timer.set_paused(false)
		pass
	pass # Replace with function body.


func _on_detection_area_area_exited(area):
	if area.name == "PlayerHitbox" and health > 0:
		#print_debug("Player exited range")
		is_player_within_range = false
		$Timer.set_paused(true)
		$AnimatedSprite2D.play("idle")
		pass
	pass # Replace with function body.

func _on_enemy_damage_hitbox_area_entered(area):
	if area.name == "MeleeHitbox" or area.name == "GroundPoundHitbox":
		_shooting_take_damage()

func _shooting_take_damage():
	health -= 1
	print_debug(name + " took damage!")
	
	if (health <= 0):
		GlobalPlayerStats.colleceted_water += 10
		get_tree().current_scene._on_water_number_updated()
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	else:
		$AnimatedSprite2D.play("damaged")
	pass

func _on_timer_timeout():
	#print_debug("Shooting player")
	if health >= 0:
		_shoot_player()
	pass # Replace with function body.
