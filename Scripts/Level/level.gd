extends Node2D

@export var levelNumber: int = 0
@export var player_prefab: PackedScene = preload("res://Scenes/Prefabs/Player/player.tscn")

func _ready():
	if $Player == null:
		_spawn_player_at_door(Global.door_spawn_number)
	
	$Player/HUD/CanvasLayer/LevelLabel.text = "Level: " + str(levelNumber)
	$Player/HUD/CanvasLayer/CollectablesLabel.text = "Collected Water: " + str(GlobalPlayerStats.colleceted_water)
	$Player/HUD/CanvasLayer/HealthLabel.text = "HealthRemaining: " + str(GlobalPlayerStats.player_health)
	_setup_coins()
	_setup_doors()
	
	$Player.player_take_damage.connect(_on_player_take_damage)
	$Player.player_used_water.connect(_on_water_number_updated)
		
func _on_door_player_entered(connectingScene, connecting_door):
	_store_door_data(connecting_door)
	get_tree().change_scene_to_file(connectingScene)

func _on_water_number_updated():
	$Player/HUD/CanvasLayer/CollectablesLabel.text = "Collected Water: " + str(GlobalPlayerStats.colleceted_water)

func _on_player_take_damage():
	$Player/HUD/CanvasLayer/HealthLabel.text = "HealthRemaining: " + str(GlobalPlayerStats.player_health)
	pass

func _on_dig_site_coin_spawned():
	_setup_coins()
	
func _setup_coins():
	if ($Coins != null):
		for coin in $Coins.get_children():
			coin.water_collected.connect(_on_water_number_updated)

func _setup_doors():
	if ($Doors != null):
		for door in $Doors.get_children():
			door.player_entered.connect(_on_door_player_entered)
	pass
			
func _store_door_data(connecting_door_number:int):
	Global.door_spawn_number = connecting_door_number
	pass

func _spawn_player_at_door(door_number: int):
	if $Doors != null:
		for door in $Doors.get_children():
			if door.door_number == door_number:
				var spawned_player = player_prefab.instantiate()
				
				if door.is_spawning_right:
					spawned_player.position = Vector2(door.position.x + door.spawn_offest, door.position.y)
				else:
					spawned_player.position = Vector2(door.position.x - door.spawn_offest, door.position.y)
					
				spawned_player.name = "Player"
				add_child(spawned_player)
	pass
