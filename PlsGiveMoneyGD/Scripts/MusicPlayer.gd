extends AudioStreamPlayer

func _ready():
	bus = "Music"

func play_stream(new_stream):
	new_stream.loop_mode = 1
	stream = new_stream
	play()