extends Area2D

@export var connectingScene = ""
signal player_entered(connectingScene)

func _on_body_entered(body):
	if body is CharacterBody2D:
		print_debug("Player Detected on Door")
		player_entered.emit(connectingScene)
	else:
		print_debug("Not colliding with player")

