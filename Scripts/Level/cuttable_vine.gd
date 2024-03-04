extends Area2D

func _on_area_entered(area):
	if area.name == "MeleeHitbox":
		queue_free()
	else:
		print_debug("not colliding with melee attack")
