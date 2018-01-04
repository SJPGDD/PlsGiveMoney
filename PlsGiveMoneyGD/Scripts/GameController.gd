extends Node2D

export(float) var company_hits_player = 1.0
export(float) var player_hits_company = 1.0

onready var player = $Player
onready var background = $Background
onready var ui = $UI
onready var value_ratio = $UI/ValueRatioDisplay
onready var score = $UI/ScoreDisplay
onready var message = load("res://Scenes/UI/Message.tscn")

var lost = false

#Duplicate enum from Projectile.gd, copy changes from there
enum ProjectileType {
	NONE, COMPANY_GOOD, COMPANY_BAD, PLAYER_GOOD, PLAYER_BAD
}

#Duplicate enum from Company.gd, copy changes from there
enum CompanyType {
	NONE, GOOD, BAD
}

func _ready():
	randomize()

func _process(delta):
	_refresh_ui()

#Called every time that a projectile hits a target which it is not 
#set to ignore. Determines what should happen to the value ratio,
#the projectile, and the target based on projectile type and target type.
#Yes, this is spaghetti, but better to have all the logic in one place
#than individually handled by the objects themselves.
func handle_collision(projectile, target):
	match projectile.type:
		ProjectileType.COMPANY_GOOD:
			if target == player: 
				player.value_ratio.add_value(company_hits_player)
		ProjectileType.COMPANY_BAD:
			if target == player: 
				player.value_ratio.add_value(-company_hits_player)
				background.glitch(5, -5, 0.2)
				background.color_jump(Color(1, 0.75, 0.75))
		ProjectileType.PLAYER_GOOD, ProjectileType.PLAYER_BAD:
			if target.is_in_group("Company"):
				if target.type == CompanyType.NONE:
					player.value_ratio.add_value(1.0)
					target.destroy()
				elif _company_type_match(projectile.type, target.type):
					player.value_ratio.add_value(player_hits_company)
					target.destroy()
				else:
					player.value_ratio.add_value(-player_hits_company)
					background.glitch(10, -10, 0.2)
					background.color_jump(Color(1, 0.5, 0.5))
	projectile.destroy()

#Returns whether a good projectile hit a good company or a bad projectile
#hit a bad company, determining the resulting value ratio added.
func _company_type_match(proj_type, comp_type):
	var good = (proj_type == ProjectileType.PLAYER_GOOD && comp_type == CompanyType.GOOD)
	var bad = (proj_type == ProjectileType.PLAYER_BAD && comp_type == CompanyType.BAD)
	return good || bad

#Called every update to ensure that the UI components contain the relevant data
func _refresh_ui():
	var val = player.value_ratio.ratio
	
	#Value Ratio Display, smoothly interpolate from the old value to the new
	value_ratio.ratio = lerp(value_ratio.ratio, val, 0.07)
	
	#Score display, integer representation
	score.text = str(int(player.score))
	val += 0.5 #Convert to 0..1 scale
	score.self_modulate = Color(1 - val, val, 1)

func lose():
	if lost: return; else: lost = true
	var things_to_stop = [$Player, $Player/PlayerWeapon, $Companies]
	for thing in things_to_stop:
		thing.set_process(false)
	$UI/LossScreen/Lose.play("Lose")