extends Node2D

onready var switcher = $"/root/SceneSwitch"

#Starts the scene with music properly looping.
#TODO: Change this when loopmode import is patched.
func _ready():
	$Music.stream.loop_mode = 1
	$Music.play()

#Callback for play button, switches to the Game scene
func _play():
	switcher.switch_to("res://Scenes/Game.tscn")

#Callback for help button, switches to the Help scene
func _help():
	print("To Help.tscn")

#Callback for settings button, switches to the Settings scene
func _settings():
	print("To Settings.tscn")

#Callback for quit button, stops the program
func _quit():
	get_tree().quit()