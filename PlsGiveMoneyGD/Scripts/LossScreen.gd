extends Panel

func _ready():
	set_process_input(false)

#For 'press any key' to return to menu, enabled by the loss animation after
#fully fading in
func _input(ev):
	if ev is InputEventKey:
		Engine.time_scale = 1.0
		$"/root/SceneSwitch".switch_to("res://Scenes/Menu.tscn", true)