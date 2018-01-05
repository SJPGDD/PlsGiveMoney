extends Node2D

onready var message = load("res://Scenes/UI/Message.tscn")

var cache = {}

func _ready():
	cache["GreatValue"] = make("Great Value", Color(0, 1, 1))
	cache["LowValue"] = make("Low Value", Color(1, 0, 1))

func _process(delta):
	if get_child_count() > 0:
		get_child(0).set_process(true)
		get_child(0).visible = true

func make(text, color, approach_position = Vector2(720/2, 250)):
	var instance = message.instance()
	instance.approach_position = approach_position
	instance.modulate = color
	instance.get_child(0).text = text
	return instance

func show(name):
	var message = cache[name]
	if message == null:
		printerr("Attempted to display nonexistent message")
		return
	message.reset()
	add_child(message)
	message.visible = false
	message.set_process(false)