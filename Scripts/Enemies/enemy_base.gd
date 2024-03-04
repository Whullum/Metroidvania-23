class_name EnemyBase

extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed: float = 30
@export var health: int = 1

func _take_damage():
	health -= 1
	
	if health <= 0:
		queue_free()
	pass

