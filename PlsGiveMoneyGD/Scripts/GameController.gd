extends Node2D

export(float) var company_hits_player = 0.5
export(float) var player_hits_company = 1.0

onready var player = $Player

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

#Called every time that a projectile hits a target which it is not 
#set to ignore. Determines what should happen to the value ratio,
#the projectile, and the target based on projectile type and target type.
#Yes, this is spaghetti, but better to have all the logic in one place
#than individually handled by the objects themselves.
func handle_collision(projectile, target):
	match projectile.type:
		ProjectileType.COMPANY_GOOD:
			if target == player: player.value_ratio.add_value(company_hits_player)
		ProjectileType.COMPANY_BAD:
			if target == player: player.value_ratio.add_value(-company_hits_player)
		ProjectileType.PLAYER_GOOD, ProjectileType.PLAYER_BAD:
			if target.is_in_group("Company"):
				if target.type == CompanyType.NONE:
					player.value_ratio.add_value(0.0)
					target.destroy()
				elif _company_type_match(projectile.type, target.type):
					player.value_ratio.add_value(player_hits_company)
					target.destroy()
				else:
					player.value_ratio.add_value(-player_hits_company)
	projectile.destroy()

#Returns whether a good projectile hit a good company or a bad projectile
#hit a bad company, determining the resulting value ratio added.
func _company_type_match(proj_type, comp_type):
	var good = (proj_type == ProjectileType.PLAYER_GOOD && comp_type == CompanyType.GOOD)
	var bad = (proj_type == ProjectileType.PLAYER_BAD && comp_type == CompanyType.BAD)
	return good || bad