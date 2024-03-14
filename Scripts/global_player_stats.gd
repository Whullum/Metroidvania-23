extends Node

var player_health: int = 5
var colleceted_water: int = 0

func _reset_stats():
	player_health = 5
	colleceted_water = 0

func _add_health():
	if player_health < 5:
		player_health += 1
