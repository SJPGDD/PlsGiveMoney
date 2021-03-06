extends Node2D

export(int) var maximum_companies = 10

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
		data.cooldown -= delta / Engine.time_scale
		if data.cooldown <= 0 && randf() < data.chance:
			data.cooldown = data.min_interval
			var ap = data.area.position
			var ad = data.area.size
			for i in int(rand_range(data.group_min, data.group_max + 1)):
				if get_child_count() >= maximum_companies: return
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
	
	#    Blizzard
	company_data = CompanySpawnParams.new()
	company_data.company = load("res://Scenes/Ships/Blizzard.tscn")
	company_data.area = Rect2(100, 100, 520, 200)
	company_data.chance = 0.01
	company_data.group_min = 1
	company_data.group_max = 3
	company_data.min_interval = 10
	array.append(company_data)
	
	#    Ubisoft
	company_data = CompanySpawnParams.new()
	company_data.company = load("res://Scenes/Ships/Ubisoft.tscn")
	company_data.area = Rect2(300, 100, 120, 300)
	company_data.chance = 0.015
	company_data.group_min = 1
	company_data.group_max = 3
	company_data.min_interval = 15
	array.append(company_data)
	
	#    Rockstar
	company_data = CompanySpawnParams.new()
	company_data.company = load("res://Scenes/Ships/Rockstar.tscn")
	company_data.area = Rect2(600, 100, 100, 300)
	company_data.chance = 0.02
	company_data.group_min = 1
	company_data.group_max = 3
	company_data.min_interval = 10
	array.append(company_data)
	
	#    EA
	company_data = CompanySpawnParams.new()
	company_data.company = load("res://Scenes/Ships/EA.tscn")
	company_data.area = Rect2(100, 100, 100, 300)
	company_data.chance = 0.01
	company_data.group_min = 1
	company_data.group_max = 3
	company_data.min_interval = 5
	array.append(company_data)
	
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