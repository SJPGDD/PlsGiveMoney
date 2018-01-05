extends Node2D

onready var message = load("res://Scenes/UI/Message.tscn")

func _process(delta):
	if get_child_count() > 0:
		get_child(0).set_process(true)
		get_child(0).visible = true

func show(text, color, approach_position = Vector2(720/2, 250)):
	var instance = message.instance()
	instance.position = Vector2(0, approach_position.y)
	instance.approach_position = approach_position
	instance.modulate = color
	instance.get_child(0).text = text
	instance.visible = false
	add_child(instance)
	instance.set_process(false)