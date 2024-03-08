extends Node

var door_spawn_number: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("Global is ready")
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("returnToMainMenu"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		print("Return to Main Menu action pressed")
		
	if event.is_action_pressed("restart_level"):
		get_tree().reload_current_scene()
