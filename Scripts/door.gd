extends Area2D

@export var connectingScene = ""
var player_within_range: bool = false
signal player_entered(connectingScene)

func _process(delta):
	if player_within_range and Input.is_action_just_pressed("interaction"):
		player_entered.emit(connectingScene)

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "Player":
		print_debug("Player Detected on Door")
		player_within_range = true

func _on_body_exited(body):
	if body is CharacterBody2D and body.name == "Player":
		player_within_range = false
