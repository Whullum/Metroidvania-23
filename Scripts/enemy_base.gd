class_name EnemyBase

extends CharacterBody2D

@export var speed: float = 30
@export var health: int = 1

func _take_damage():
	health -= 1
	pass
