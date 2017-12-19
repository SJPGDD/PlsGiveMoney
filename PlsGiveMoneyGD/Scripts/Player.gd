extends Node2D

#Position when the player spawns
export(Vector2) var spawn = Vector2(0, 0)

#Horizontal velocity in px/sec
export(Vector2) var move_speed = 480

#The number of previous companies remembered
export(int) var ratio_buffer_size = 20

#The ratio at which the game is lost
export(float) var minimum_ratio = -0.75

#Points/sec when value ratio is 1.0
export(int) var score_per_second = 1_000

#Instance of ValueRatio class, which is created using the above init values
onready var value_ratio = load("res://Scripts/ValueRatio.gd").new(ratio_buffer_size, 0, minimum_ratio, 1.0)

#Reference to the debug label for displaying variables
onready var debug = $"../UI/DebugReadout"

#Current number of points the player earned in this run
var score = 0

#Calls spawn when the player is added to the SceneTree
func _ready():
	spawn()

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
	score = 0
	value_ratio.reset(20, 0.0)

#Called every time that a projectile hits a target which it is not 
#set to ignore. Determines what should happen to the value ratio,
#the projectile, and the target based on projectile type and target type.
#Yes, this is spaghetti, but better to have all the logic in one place
#than individually handled by the objects themselves.
#TODO: Refactor out to a different script, like GameController
func handle_collision(projectile, target):
	match projectile.projectile_type:
		projectile.ProjectileType.NONE: pass
		projectile.ProjectileType.COMPANY_GOOD:
			if target == self: value_ratio.add_value(0.5)
		projectile.ProjectileType.COMPANY_BAD:
			if target == self: value_ratio.add_value(-0.5)
		projectile.ProjectileType.PLAYER_GOOD:
			if target.is_in_group("Company"):
				if target.company_type == target.CompanyType.GOOD:
					value_ratio.add_value(1.0)
					target.destroy()
				elif target.company_type == target.CompanyType.BAD:
					value_ratio.add_value(-1.0)
				elif target.company_type == target.CompanyType.NONE:
					value_ratio.add_value(0.0)
					target.destroy()
		projectile.ProjectileType.PLAYER_BAD:
			if target.is_in_group("Company"):
				if target.company_type == target.CompanyType.GOOD:
					value_ratio.add_value(-1.0)
				elif target.company_type == target.CompanyType.BAD:
					value_ratio.add_value(1.0)
					target.destroy()
				elif target.company_type == target.CompanyType.NONE:
					value_ratio.add_value(0.0)
					target.destory()
	projectile.destroy()

#Moves the player horizontally either left or
#right based on the actions "move_left/right",
#adjusted for move_speed and delta
func _move_horizontally(delta):
	if Input.is_action_pressed("move_left"):
		position.x -= move_speed * delta
	elif Input.is_action_pressed("move_right"):
		position.x += move_speed * delta

#Ensures that the player is always completely on
#screen by constraining its x position to between
#half width and screen width minus half width
func _clamp_to_screen():
	var tex_half_width = $Sprite.texture.get_size().x / 2
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, tex_half_width, screen_width - tex_half_width)