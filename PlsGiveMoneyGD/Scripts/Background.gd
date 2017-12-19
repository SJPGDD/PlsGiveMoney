extends Sprite

func _process(delta):
	_lerp_reset_color()

#Controls the color aberration shader
#attached to the background sprite. The strength
#of the shader will go from 0..first_peak, then
#from first_peak..second_peak, then from second_peak
#to 0 over duration in seconds.
func glitch(first_peak, second_peak, duration):
	var player = $Glitch
	var anim = player.get_animation("glitch")
	anim.set_length(duration)
	var vals = [first_peak, second_peak, 0]
	for i in 3:
		anim.track_remove_key(0, i)
		anim.track_insert_key(0, i * duration / 3.0, vals[i])
	player.play("glitch")

func color_jump(color):
	modulate = color

func _lerp_reset_color():
	modulate.r = lerp(modulate.r, 1.0, 0.07)
	modulate.g = lerp(modulate.g, 1.0, 0.07)
	modulate.b = lerp(modulate.b, 1.0, 0.07)