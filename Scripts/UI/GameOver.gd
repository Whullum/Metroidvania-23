extends Control

@onready var load_main_menu = preload("res://Scenes/Menus/MainMenu.tscn") as PackedScene

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_main_menu)
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
