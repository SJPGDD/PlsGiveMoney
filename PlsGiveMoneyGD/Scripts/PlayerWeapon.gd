extends Sprite

export(int) var projectile_speed = 300 #px/sec
export(PackedScene) var good_projectile
export(PackedScene) var bad_projectile

onready var current_projectile = good_projectile

func _ready():
	set_process(true)

func _process(delta):
	weapon_select()

func weapon_select():
	if Input.is_action_just_pressed("toggle_projectile"):
		if current_projectile == good_projectile: current_projectile = bad_projectile
		else: current_projectile = good_projectile

func _draw():
	draw_line(Vector2(0,0), get_local_mouse_position(), Color(0, 1, 0), 10.0, true)