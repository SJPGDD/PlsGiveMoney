extends Node2D

onready var company_spawn_data = _register_companies()

func _process(delta):
	_run_spawner(delta)

#Every _process frame, this function iterates through the company spawn
#data to decrement cooldowns. If a spawn_data is ready to spawn again,
#and its random chance is triggered, then the spawn_data's cooldown 
#is again set to its minimum interval, then a random number of companies
#between group_min and group_max are spawned, at random positions inside
#the area of the spawn_data.
func _run_spawner(delta):
	for data in company_spawn_data:
		data.cooldown -= delta
		if data.cooldown <= 0 && randf() < data.chance:
			data.cooldown = data.min_interval
			var ap = data.area.position
			var ad = data.area.size
			for i in int(rand_range(data.group_min, data.group_max + 1)):
				var company = data.company.instance()
				company.position.x = rand_range(ap.x, ap.x + ad.x)
				company.position.y = rand_range(ap.y, ap.y + ad.y)
				add_child(company)

#Populates the company_spawn_data array with the different companies
#and the params for spawning them. This is the function to modify
#when adding new companies to the game (in addition to their inherited scene)
func _register_companies():
	var array = []
	var company_data
	
	#    Generic Company (Debug)
	company_data = CompanySpawnParams.new()
	company_data.company = load("res://Scenes/Ships/Company.tscn")
	company_data.area = Rect2(0, 0, 720, 400)
	company_data.chance = 0.007
	company_data.group_min = 1
	company_data.group_max = 4
	company_data.min_interval = 10
	array.append(company_data)
	
	#    Buzzard (TENTATIVE PARODY NAMES)
	#company_data = CompanySpawnParams.new()
	
	#    REE-A
	
	#    Act-Revision
	
	#    Ubitener Get it? Ubi is where in latin, so, soft in latin, Ubi Tener
	
	return array

#Object to encapsulate the different parameters for spawning a company.
#Includes PackedScene for the company, the area on-screen that it may
#spawn in, the probability that it will spawn (0..1) on any given _process,
#the minimum number to spawn at a time, the maximum number to spawn at a time,
#and the minimum amount of time between spawn waves for this company. The
#cooldown var tracks the amount of time remaining until this company can
#spawn another wave.
class CompanySpawnParams:
	var company
	var area
	var chance
	var group_min
	var group_max
	var min_interval
	
	var cooldown = 0