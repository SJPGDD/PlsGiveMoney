extends Node2D

enum CompanyType {
	NONE, GOOD, BAD
}

export(int) var move_speed = 480

export(CompanyType) var company_type

export(PackedScene) var projectile

export(int) var projectile_speed

export(int) var firing_rate = 1

onready var player = $"/root/Game/Player"

var time_alive = 0

var cooldown = 0

func _process(delta):
	time_alive += delta
	position += _velocity_for_time(time_alive) * delta
	cooldown -= delta
	_weapon_fire()

func destroy():
	queue_free()

func _velocity_for_time(time_alive):
	return move_speed * Vector2(cos(time_alive), sin(time_alive))

func _weapon_fire():
	if cooldown <= 0 && projectile != null && player != null:
		var dir = (player.position - position).normalized()
		var projectile = self.projectile.instance()
		projectile.position = position
		projectile.velocity = dir * projectile_speed
		$"/root/Game/Projectiles".add_child(projectile)
		cooldown = 1.0 / firing_rate