extends Panel

func _ready():
	set_process_input(true)

func _input(ev):
	if ev is InputEventKey:
		$"/root/SceneSwitch".switch_to("res://Scenes/Menu.tscn")