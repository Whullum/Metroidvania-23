extends Node2D

@export var levelNumber: int = 0

func _ready():
	$Player/HUD/CanvasLayer/LevelLabel.text = "Level: " + str(levelNumber)
	$Player/HUD/CanvasLayer/CollectablesLabel.text = "Gems: " + str(Global.GemsCollected)
	if ($Coins != null):
		for coin in $Coins.get_children():
			coin.coinCollected.connect(_on_gem_collected)
		
func _on_door_player_entered(connectingScene):
	get_tree().change_scene_to_file(connectingScene)

func _on_gem_collected():
	$Player/HUD/CanvasLayer/CollectablesLabel.text = "Gems: " + str(Global.GemsCollected)
