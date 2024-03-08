extends ColorRect

@export var camera_zoom: float = 1.0
@onready var player: = $"."
@onready var camera: = $SubViewportContainer/SubViewport/Camera2D

func _process(delta: float) -> void:
	if player:
		camera.zoom = camera_zoom * Vector2(camera.zoom.x, camera.zoom.y)
		camera.position = Vector2(player.position.x, player.position.y)
	else:
		print_debug("No player found for minimap camera")
	pass
