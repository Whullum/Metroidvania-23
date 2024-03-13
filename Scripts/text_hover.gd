extends Node

func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Node2D, "position", Vector2($Node2D.position.x, $Node2D.position.y + 2.5), 1)
	tween.tween_property($Node2D, "position", Vector2($Node2D.position.x, $Node2D.position.y - 2.5), 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
