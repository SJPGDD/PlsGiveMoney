extends Node2D

onready var company_spawn_data = register_companies()

func register_companies():
	var array = []
	var current_company
	
	current_company = CompanySpawnParams.new()
	current_company.company = load("res://Scenes/Ships/Company.tscn")
	current_company.area = Rect2(0, 0, 720, 400)
	current_company.chance = 0.007
	current_company.group_min = 1
	current_company.group_max = 4
	current_company.min_interval = 10
	array.append(current_company)
	
	current_company = CompanySpawnParams.new()
	
	return array

func _process(delta):
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

class CompanySpawnParams:
	var company
	var area
	var chance
	var group_min
	var group_max
	var min_interval
	
	var cooldown = 0