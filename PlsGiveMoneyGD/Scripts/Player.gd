extends Node2D

export(Vector2) var spawn = Vector2(0, 0)
export(Vector2) var move_speed = 480
export(int) var start_health = 100

var health = start_health

onready var debug = $"../UI/DebugReadout"

func _ready():
	spawn()

func _process(delta):
	move_horizontally(delta)
	clamp_to_screen()
	
	debug.set_line(0, "Pos", position)
	debug.set_line(1, "Health", health)

func spawn():
	position = spawn
	health = start_health

func move_horizontally(delta):
	if Input.is_key_pressed(KEY_A):
		position.x -= move_speed * delta
	elif Input.is_key_pressed(KEY_D):
		position.x += move_speed * delta

func clamp_to_screen():
	var tex_half_width = $Sprite.texture.get_size().x / 2
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, tex_half_width, screen_width - tex_half_width)