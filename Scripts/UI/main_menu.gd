extends Control

signal start_game()
@onready var buttons_v_box = %ButtonsVBox
@onready var start_level = preload("res://Scenes/Levels/Build Levels/A3-B3.tscn") as PackedScene
@onready var load_settings = preload("res://Scenes/Menus/SettingsMenu.tscn") as PackedScene
@onready var load_controls = preload("res://Scenes/Menus/ControlsMenu.tscn") as PackedScene
@onready var load_credits = preload("res://Scenes/Menus/CreditsMenu.tscn") as PackedScene

func _ready() -> void:
	focus_button()
	Global._play_main_menu()

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	start_game.emit()
	GlobalPlayerStats._reset_stats()
	Global._stop_menu_music()
	Global._play_music()
	hide()
	
func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_settings)
	
func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_controls)
	
func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_credits)
	
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
