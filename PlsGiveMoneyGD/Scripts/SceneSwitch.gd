extends CanvasModulate

#TODO: Handle music through this or another autoload singleton

#The scene to switch to at the end of the animation
var target_scene = null

#Sets the target scene path to the scene param, then pauses the tree
#to ensure that the current scene stops updating while it fades out.
func switch_to(scene):
	target_scene = scene
	get_tree().set_pause(true)
	$Fade.play("FadeOut")

#After the FadeOut anim finishes, it calls this, which then verifies that
#a valid replacement scene has been set, before attempting to change to it,
#and then playing the FadeIn animation
func _faded_out():
	if target_scene != null:
		get_tree().change_scene(target_scene)
		$Fade.play("FadeIn")
	else:
		print("Attempted change to null scene.")

#Unpauses the tree when the scene has finished fading in
func _faded_in():
	get_tree().set_pause(false)