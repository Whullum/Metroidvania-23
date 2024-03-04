extends Area2D

@export var climbable_vine_object: PackedScene = preload("res://Scenes/climbable_vine.tscn")

func _on_area_entered(area):
	if area.name == "WateringCanHitbox":
		var spawned_climbable_vine = climbable_vine_object.instantiate()
		spawned_climbable_vine.position = self.position
		get_parent().add_child(spawned_climbable_vine)
		queue_free()
