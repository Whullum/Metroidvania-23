extends Area2D

class_name Coin

var is_player_within_range: bool
var player_position: Vector2
@export var magnet_weight: float = .05

signal water_collected

func _ready():
	$CollectionHitbox/AnimatedSprite2D.play("idle")
	pass
	
func _physics_process(delta):
	if is_player_within_range:
		_move_towards(player_position)
	pass

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "Player":
		print_debug("Coin collected!")
		GlobalPlayerStats.colleceted_water += 1
		#GlobalPlayerStats._add_health()
		water_collected.emit()
		queue_free()

func _move_towards(position: Vector2):
	self.position = self.position.lerp(position, magnet_weight)
