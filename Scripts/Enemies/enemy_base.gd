class_name EnemyBase

extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed: float = 30
@export var health: int = 1

func _take_damage():
	health -= 1
	
	if health <= 0:
		GlobalPlayerStats.colleceted_water += 10
		get_tree()._on_water_number_updated()
		queue_free()
	pass
