extends Node2D

onready var switcher = $"/root/SceneSwitch"

func _ready():
	$"/root/MusicPlayer".play_stream(load("res://Assets/Audio/Music/Menu.wav"))

#Callback for play button, switches to the Game scene
func _play():
	switcher.switch_to("res://Scenes/Game.tscn", true)

#Callback for help button, switches to the Help scene
func _help():
	switcher.switch_to("res://Scenes/Help.tscn")

#Callback for settings button, switches to the Settings scene
func _settings():
	switcher.switch_to("res://Scenes/Settings.tscn")

#Callback for quit button, stops the program
func _quit():
	get_tree().quit()