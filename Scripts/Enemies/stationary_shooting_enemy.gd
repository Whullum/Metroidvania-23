extends EnemyBase

@export var bullet_object: PackedScene = preload("res://Scenes/coin.tscn")

var is_player_within_range: bool = false
var player_position: Vector2
var player

func _ready():
	$Timer.start()
	$Timer.set_paused(true)
	player = get_parent().get_node("Player")
	pass

func _physics_process(delta):
	if is_player_within_range:
		player_position = player.position
	pass

func _shoot_player():
	var spawned_bullet = bullet_object.instantiate()
	spawned_bullet.position = global_position
	spawned_bullet._set_bullet_velocity(player_position, global_position)
	get_parent().add_child(spawned_bullet)
	pass

func _angle_towards_player():
	pass

func _on_detection_area_area_entered(area):
	if area.name == "PlayerHitbox":
		#print_debug("Player within range")
		player_position = area.global_position
		is_player_within_range = true
		$Timer.set_paused(false)
		pass
	pass # Replace with function body.


func _on_detection_area_area_exited(area):
	if area.name == "PlayerHitbox":
		#print_debug("Player exited range")
		is_player_within_range = false
		$Timer.set_paused(true)
		pass
	pass # Replace with function body.

func _on_enemy_damage_hitbox_area_entered(area):
	if area.name == "MeleeHitbox":
		print_debug(name + " took damage!")
		_take_damage()

func _on_timer_timeout():
	#print_debug("Shooting player")
	_shoot_player()
	pass # Replace with function body.
