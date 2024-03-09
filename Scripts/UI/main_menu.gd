extends Control

signal start_game()
@onready var buttons_v_box = %ButtonsVBox
@onready var start_level = preload("res://Scenes/level_1.tscn") as PackedScene
@onready var load_settings = preload("res://Scenes/Menus/SettingsMenu.tscn") as PackedScene

func _ready() -> void:
	focus_button()

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	start_game.emit()
	hide()
	
func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_settings)
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_visibility_changed() -> void:
	if visible:
		focus_button()
		
func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()
