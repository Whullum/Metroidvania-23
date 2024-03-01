extends Area2D

signal coinCollected

func _ready():

	pass

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "Player":
		print_debug("Coin collected!")
		Global.GemsCollected += 1
		coinCollected.emit()
		queue_free()
