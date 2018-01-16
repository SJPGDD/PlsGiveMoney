extends AudioStreamPlayer

func _ready():
	bus = "Music"

func play_stream(new_stream):
	if new_stream == stream: return
	new_stream.loop_mode = 1
	stream = new_stream
	play()