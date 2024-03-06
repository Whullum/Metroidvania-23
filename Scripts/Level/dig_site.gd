extends Area2D

@export var coin_object: PackedScene = preload("res://Scenes/Prefabs/LevelObjects/coin.tscn")
@export var coins_to_spawn: int = 3

signal coin_spawned

func _ready():
	#get_parent()._on_dig_site_coin_spawned.connect(coin_spawned)
	pass

func _on_area_entered(area):
	if area.name == "DigHitbox":
		for i in coins_to_spawn:
			var spawned_coin = coin_object.instantiate()
			var spawn_position: Vector2
			spawn_position = Vector2(global_position) + (20 * Vector2(cos((i + 1) * PI/(coins_to_spawn + 1)), -sin((i + 1) * PI/(coins_to_spawn + 1))))
			spawned_coin.position = spawn_position
			if get_parent().get_node("Coins") == null:
				var new_coin_node = Node.new()
				new_coin_node.name = "Coins"
				get_parent().add_child(new_coin_node)
			spawned_coin.water_collected.connect(get_parent()._on_water_number_updated)
			get_parent().get_node("Coins").add_child(spawned_coin)
			coin_spawned.emit()
		queue_free()
	else:
		print_debug("not colliding with dig attack")
