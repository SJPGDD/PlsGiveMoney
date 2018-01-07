extends Sprite

export(int) var scroll_speed = 100 #px/sec

func _process(delta):
	_translate(delta)
	_lerp_reset_color()

#Controls the color aberration shader
#attached to the background sprite. The strength
#of the shader will go from 0..first_peak, then
#from first_peak..second_peak, then from second_peak
#to 0 over duration in seconds.
func glitch(first_peak, second_peak, duration):
	var player = $Glitch
	var anim = player.get_animation("Glitch")
	anim.set_length(duration)
	var vals = [first_peak, second_peak, 0]
	for i in 3:
		anim.track_remove_key(0, i)
		anim.track_insert_key(0, i * duration / 3.0, vals[i])
	player.play("Glitch")

#Makes the background color immediately modulate to the color param
func color_jump(color):
	modulate = color

#Restores the modulate to white (none) over time
func _lerp_reset_color():
	modulate.r = lerp(modulate.r, 1.0, 0.07)
	modulate.g = lerp(modulate.g, 1.0, 0.07)
	modulate.b = lerp(modulate.b, 1.0, 0.07)

func _translate(delta):
	position.y += scroll_speed * delta
	if position.y >= 900:
		position.y = -8192 + 900