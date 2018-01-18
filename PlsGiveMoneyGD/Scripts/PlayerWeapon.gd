extends Sprite

#Velocity of a projectile in px/sec
export(int) var projectile_speed

#Number of projectiles/sec
export(int) var firing_rate

#The scene for the good projectile to instance
export(PackedScene) var good_projectile

#The scene for the bad projectile to instance
export(PackedScene) var bad_projectile

#The scene which will be instanced at next weapon fire
onready var current_projectile = good_projectile

#Seconds until next weapon fire, can be negative
var cooldown = 0

#Whether to shoot towards the mouse cursor
var free_aim = false

#Angle variance from shot to shot, random
var spread = 0.05

#Checks for weapon select, updates the cooldown
#then checks for weapon fire
func _process(delta):
	_weapon_select()
	cooldown -= delta / Engine.time_scale
	_weapon_fire()

#If the "toggle_projectile" action is just pressed, then
#the current_projectile will toggle between good and bad,
#based on which is already selected
func _weapon_select():
	if Input.is_action_just_pressed("toggle_projectile"):
		if current_projectile == good_projectile: current_projectile = bad_projectile
		else: current_projectile = good_projectile
		$"/root/Game/UI/WeaponSelected".toggle_selected()

#If the "fire_projectile" action is held down and the cooldown
#is less than zero, the weapon will fire the current_projectile
#in the relative direction of the mouse cursor to the ship, as
#long as that direction faces up from the ship. These projectiles
#are added as children of /root/Game/Projectiles. The cooldown is
#then set as the reciprocal of firing rate, to prevent firing
#for some fraction of a second
func _weapon_fire():
	if Input.is_action_pressed("fire_projectile") && cooldown <= 0:
		var dir = _get_firing_direction()
		if dir.y > 0: return #No need to fire backwards
		var projectile = current_projectile.instance()
		projectile.position = global_position #Weapon is rel to player
		projectile.velocity = dir * projectile_speed
		$"/root/Game/Projectiles".add_child(projectile)
		cooldown = 1.0 / firing_rate

#Returns the unit vector pointing from the ship to the mouse cursor
func _get_firing_direction():
	if free_aim:
		return get_local_mouse_position().normalized()
	else:
		return Vector2(0, -1).rotated(rand_range(-spread, spread))