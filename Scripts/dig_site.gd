extends Area2D

@export var coin_object: PackedScene = preload("res://Scenes/coin.tscn")
@export var coins_to_spawn: int = 3

signal coin_spawned

func _on_area_entered(area):
	if area.name == "DigHitbox":
		for i in coins_to_spawn:
			var spawned_coin = coin_object.instantiate()
			var spawn_position: Vector2
			spawn_position = Vector2(self.position) + 20 * Vector2(cos((i + 1) * PI/(coins_to_spawn + 1)), -sin((i + 1) * PI/(coins_to_spawn + 1)))
			spawned_coin.position = spawn_position
			get_parent().add_child(spawned_coin)
			coin_spawned.emit()
		queue_free()
	else:
		print_debug("not colliding with dig attack")
