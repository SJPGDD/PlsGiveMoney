extends Sprite

onready var debug = $"../UI/DebugReadout"

var sc = 0
func _process(delta):
	debug.set_line(2, "Time Scale", Engine.get_time_scale())
	sc += delta
	Engine.set_time_scale(sin(sc) / 1.5 + 1)
	material.set_shader_param("glitchAmount", sin(sc) * 5)

func glitch(first_peak, second_peak, duration):
	var player = $Glitch
	var anim = player.get_animation("glitch")
	anim.set_length(duration)
	var vals = [first_peak, second_peak, 0]
	for i in 3:
		anim.track_remove_key(0, i)
		anim.track_insert_key(0, i * duration / 3.0, vals[i])
	player.play("glitch")
