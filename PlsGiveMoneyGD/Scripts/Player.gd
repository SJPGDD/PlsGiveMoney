extends Node2D

#Position when the player spawns
export(Vector2) var spawn = Vector2(0, 0)

#Horizontal velocity in px/sec
export(Vector2) var move_speed = 480

#The snappiness of interpolated horizontal movement
export(float) var movement_snap = 0.3

#The number of previous companies remembered
export(int) var ratio_buffer_size = 40

#The ratio at which the game is lost
export(float) var minimum_ratio = -0.75

#Points/sec when value ratio is 1.0
export(int) var score_per_second = 1_000

#Instance of ValueRatio class, which is created using the above init values
onready var value_ratio = load("res://Scripts/ValueRatio.gd").new(ratio_buffer_size, 0, minimum_ratio, 1.0)

#Current number of points the player earned in this run
var score = 0

#Lerping tracker variable for smooth horizontal movement
var target_x = spawn.x

#Calls spawn when the player is added to the SceneTree
func _ready():
	spawn()
	value_ratio.connect("below_minimum", $"/root/Game", "lose")
	value_ratio.connect("low_warning", $"/root/Game/Messages", "show", ["LowValue"])
	value_ratio.connect("above_maximum", $"/root/Game/Messages", "show", ["GreatValue"])

#Updates horizontal position, increments score,
#and updates debug display as needed
func _process(delta):
	_move_horizontally(delta)
	_clamp_to_screen()
	_increase_score(delta)

#Sets position to the spawn position, sets score to 0,
#and restores the value ratio to its initial state
func spawn():
	position = spawn
	target_x = position.x
	score = 0
	value_ratio.reset(ratio_buffer_size, 0.0)

#Moves the player horizontally either left or
#right based on the actions "move_left/right",
#adjusted for move_speed and delta, and interpolated over time
func _move_horizontally(delta):
	if Input.is_action_pressed("move_left"):
		target_x -= move_speed * delta
	elif Input.is_action_pressed("move_right"):
		target_x += move_speed * delta
	position.x = lerp(position.x, target_x, movement_snap)

#Ensures that the player is always completely on
#screen by constraining its x position to between
#half width and screen width minus half width
func _clamp_to_screen():
	var tex_half_width = $Sprite.texture.get_size().x / 2
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, tex_half_width, screen_width - tex_half_width)
	target_x = clamp(target_x, tex_half_width, screen_width - tex_half_width)

func _increase_score(delta):
	score += score_per_second * (value_ratio.ratio + 1) * delta