extends Sprite

func glitch(first_peak, second_peak, duration):
	var player = $Glitch
	var anim = player.get_animation("glitch")
	anim.set_length(duration)
	var vals = [first_peak, second_peak, 0]
	for i in 3:
		anim.track_remove_key(0, i)
		anim.track_insert_key(0, i * duration / 3.0, vals[i])
	player.play("glitch")
