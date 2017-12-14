extends Sprite

export(int) var projectile_speed #px/sec
export(int) var firing_rate
export(PackedScene) var good_projectile
export(PackedScene) var bad_projectile

onready var current_projectile = good_projectile

var cooldown = 0

func _process(delta):
	weapon_select()
	cooldown -= delta
	weapon_fire()

func weapon_select():
	if Input.is_action_just_pressed("toggle_projectile"):
		if current_projectile == good_projectile: current_projectile = bad_projectile
		else: current_projectile = good_projectile

func weapon_fire():
	if Input.is_action_pressed("fire_projectile") and cooldown <= 0:
		var dir = get_firing_direction()
		if dir.y > 0: return #No need to fire backwards
		var projectile = current_projectile.instance()
		projectile.position = global_position
		projectile.velocity = dir * projectile_speed
		$"/root/Game/Projectiles".add_child(projectile)
		cooldown = 1.0 / firing_rate

func get_firing_direction():
	return get_local_mouse_position().normalized()