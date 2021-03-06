extends Node2D

onready var message = load("res://Scenes/UI/Message.tscn")

var cache = {}

func _ready():
	cache["GreatValue"] = make("Great Value", Color(0, 1, 1))
	cache["LowValue"] = make("Danger: Low Value", Color(1, 0, 1))
	cache["DoubleScore"] = make("2x Score!", Color(0, 0.75, 1.0))
	#cache["FreeValue"] = make("Free Value!", Color(0, 0.75, 1.0))
	cache["SpeedBoost"] = make("Speed Boost!", Color(0, 0.75, 1.0))
	#cache["FreeAim"] = make("Free Aim!", Color(0, 0.75, 1.0))
	cache["BulletTime"] = make("Bullet Time!", Color(0, 0.75, 1.0))
	cache["FirinMaLazor"] = make("Firin' Ma Lazor!", Color(0, 0.75, 1.0))

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

func show(message_name):
	var message = cache[message_name]
	if message == null:
		printerr("Attempted to display nonexistent message")
		return
	message.reset()
	add_child(message)
	message.visible = false
	message.set_process(false)