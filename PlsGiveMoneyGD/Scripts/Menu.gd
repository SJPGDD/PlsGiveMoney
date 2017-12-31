extends Node2D

#Starts the scene with music properly looping.
#TODO: Change this when loopmode import is patched.
func _ready():
	$Music.stream.loop_mode = 1
	$Music.play()

#Callback for play button, switches to the Game scene
func _play():
	$"/root/SceneSwitch".switch_to("res://Scenes/Game.tscn")

#Callback for settings button, switches to the Settings scene
func _settings():
	print("To Settings.tscn")
	pass

#Callback for quit button, stops the program
func _quit():
	get_tree().quit()
	pass
