extends Node

var door_spawn_number: int = 0
var audio_player: AudioStreamPlayer2D
var main_menu_audio: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("Global is ready")
	audio_player = AudioStreamPlayer2D.new()
	var music_stream = load("res://Audio/ancient-garden-main-level_v1 (1).mp3")
	audio_player.set_stream(music_stream)
	audio_player.volume_db = 1
	audio_player.pitch_scale = 1
	audio_player.set_bus("Music")
	add_child(audio_player)
	#audio_player.play()
	_load_main_menu_music()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("returnToMainMenu"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		print("Return to Main Menu action pressed")
		
	if event.is_action_pressed("restart_level"):
		get_tree().reload_current_scene()

func _go_to_gameover():
	get_tree().change_scene_to_file("res://Scenes/Menus/GameOver.tscn")
	audio_player.stop()

func _play_music():
	audio_player.play()
	
func _play_main_menu():
	main_menu_audio.play()
	
func _stop_menu_music():
	main_menu_audio.stop()

func _load_main_menu_music():
	main_menu_audio = AudioStreamPlayer2D.new()
	var music_stream = load("res://Audio/ancient-garden-menu-v1 (1).mp3")
	main_menu_audio.set_stream(music_stream)
	main_menu_audio.volume_db = 1
	main_menu_audio.pitch_scale = 1
	main_menu_audio.set_bus("Music")
	add_child(main_menu_audio)
