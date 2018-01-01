extends Node2D

#Position when the player spawns
export(Vector2) var spawn = Vector2(0, 0)

#Horizontal velocity in px/sec
export(Vector2) var move_speed = 480

#The snappiness of interpolated horizontal movement
export(float) var movement_snap = 0.3

#The number of previous companies remembered
export(int) var ratio_buffer_size = 20

#The ratio at which the game is lost
export(float) var minimum_ratio = -0.75

#Points/sec when value ratio is 1.0
export(int) var score_per_second = 1_000

#Instance of ValueRatio class, which is created using the above init values
onready var value_ratio = load("res://Scripts/ValueRatio.gd").new(ratio_buffer_size, 0, minimum_ratio, 1)

#Reference to the debug label for displaying variables
onready var debug = $"../UI/DebugReadout"

#Current number of points the player earned in this run
var score = 0

#Lerping tracker variable for smooth horizontal movement
var target_position = Vector2()

#Calls spawn when the player is added to the SceneTree
func _ready():
	spawn()
	value_ratio.connect("below_minimum", get_parent(), "lose")

#Updates horizontal position, increments score,
#and updates debug display as needed
func _process(delta):
	_move_horizontally(delta)
	_clamp_to_screen()
	
	score += score_per_second * (value_ratio.ratio + 1) * delta
	
	debug.set_line(0, "Pos", position)
	debug.set_line(1, "Value Ratio", value_ratio.ratio)
	debug.set_line(2, "Score", score)

#Sets position to the spawn position, sets score to 0,
#and restores the value ratio to its initial state
func spawn():
	position = spawn
	target_position = position
	score = 0
	value_ratio.reset(20, 0.0)

#Moves the player horizontally either left or
#right based on the actions "move_left/right",
#adjusted for move_speed and delta, and interpolated over time
func _move_horizontally(delta):
	if Input.is_action_pressed("move_left"):
		target_position.x -= move_speed * delta
	elif Input.is_action_pressed("move_right"):
		target_position.x += move_speed * delta
	position.x = lerp(position.x, target_position.x, movement_snap)

#Ensures that the player is always completely on
#screen by constraining its x position to between
#half width and screen width minus half width
func _clamp_to_screen():
	var tex_half_width = $Sprite.texture.get_size().x / 2
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, tex_half_width, screen_width - tex_half_width)