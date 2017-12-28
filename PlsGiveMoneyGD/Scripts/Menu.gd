extends Node2D

func _ready():
	$Music.stream.loop_mode = 1
	$Music.play()

func _play():
	$"/root/SceneSwitch".switch_to("res://Scenes/Game.tscn")

func _settings():
	print("To Settings.tscn")
	pass

func _quit():
	get_tree().quit()
	pass
