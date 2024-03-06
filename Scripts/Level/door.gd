extends Area2D

@export var connectingScene: String = ""
@export var door_number: int
@export var is_spawning_right: bool = true
@export var spawn_offest: float = 15.0
var player_within_range: bool = false
signal player_entered(connectingScene, door_number)

func _process(delta):
	if player_within_range and Input.is_action_just_pressed("interaction"):
		player_entered.emit(connectingScene, door_number)

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "Player":
		print_debug("Player Detected on Door")
		player_within_range = true

func _on_body_exited(body):
	if body is CharacterBody2D and body.name == "Player":
		player_within_range = false
