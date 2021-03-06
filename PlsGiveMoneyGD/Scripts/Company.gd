extends Node2D

const Explosion = preload("res://Scenes/Effects/Explosion.tscn")

#The different types of company
enum CompanyType {
	NONE, GOOD, BAD
}

#Velocity in px/sec
export(int) var move_speed = 480

#Spin in deg/sec
export(float) var spin_speed = 0

#Configurable variable for this company's type
export(CompanyType) var type

#Scene for the projectile this company fires (if any)
export(PackedScene) var projectile

#Speed of the projectile this company fires (if any)
export(int) var projectile_speed

#How often this company fires a projectile per second (if any)
export(int) var firing_rate = 1

#Cached access to the player, for position tracking
onready var player = $"/root/Game/Player"

onready var effects = $"/root/Game/Effects"

#Tracks how long this company has existed, for velocity over time
var time_alive = 0

#Amount of time until this company can fire again
var cooldown = 0

#Increments time alive, moves the company by its velocity as determined
#by _velocity_for_time, decrements the cooldown, then attempts to
#fire weapon
func _process(delta):
	time_alive += delta
	position += _velocity_for_time(time_alive) * delta
	rotation_degrees += spin_speed * delta
	cooldown -= delta
	_weapon_fire()

#Called by player when a collision warranting this company's removal
#from the scene occurs (eg bad player projectile on bad company)
func destroy(is_good):
	var ex = Explosion.instance()
	ex.position = position
	if is_good:
		ex.process_material.color = Color(0, 1, 1, 0.05)
		ex.get_node("GoodHitSound").play()
	else:
		ex.process_material.color = Color(1, 0, 1, 0.05)
		ex.get_node("BadHitSound").play()
	effects.add_child(ex)
	queue_free()

#Returns the velocity vector for the given time. Default implementation
#moves in a circle scaled by move_speed.
func _velocity_for_time(time_alive):
	return move_speed * Vector2(cos(time_alive), sin(time_alive))

#If the cooldown is less than zero, and the company has a projectile,
#and is in a scene with a player, and is on screen, the company will fire 
#its projectile from its current position in the direction of the player 
#at the time of the projectile's instantiation
func _weapon_fire():
	if cooldown <= 0 && projectile != null && player != null && get_viewport_rect().has_point(position):
		var dir = _get_firing_direction()
		var projectile = self.projectile.instance()
		projectile.position = position
		projectile.velocity = dir * projectile_speed
		$"/root/Game/Projectiles".add_child(projectile)
		cooldown = 1.0 / firing_rate

#Returns the unit vector direction for the company to shoot towards. By default,
#shoots towards the player, but can be overriden.
func _get_firing_direction():
	return (player.position - position).normalized()