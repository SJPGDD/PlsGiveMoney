extends CanvasModulate

var target_scene = null

func switch_to(scene):
	target_scene = scene
	get_tree().set_pause(true)
	$Fade.play("FadeOut")

func _faded_out():
	if target_scene != null:
		get_tree().change_scene(target_scene)
		$Fade.play("FadeIn")
	else:
		print("Attempted change to null scene.")

func _faded_in():
	get_tree().set_pause(false)