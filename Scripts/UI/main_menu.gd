extends Control

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Test Levels/level_3.tscn")
	print("Start Game")

func _on_quit_button_pressed():
	get_tree().quit()
