extends Node2D

onready var player = $"/root/Game/Player"
onready var messages = $"/root/Game/Messages"
onready var active = $"/root/Game/PowerupActive"

var active_powerups = []
var types = [DoubleScorePowerup, SpeedBoostPowerup, BulletTimePowerup, ImaFirinMaLazorPowerup]

func _ready():
	player.connect("reached_powerup", self, "_choose_random_powerup")

func _process(delta):
	_consume_durations(delta)

func activate_powerup(powerup):
	powerup.activate(player)
	active_powerups.append(powerup)
	messages.show(powerup.message)
	if powerup.duration > 0: active.emitting = true

func deactivate_powerup(powerup):
	powerup.deactivate(player)
	active_powerups.erase(powerup)
	if active_powerups.size() == 0: active.emitting = false

func _consume_durations(delta):
	for powerup in active_powerups:
		powerup.duration -= delta
		if powerup.duration <= 0:
			deactivate_powerup(powerup)

func _choose_random_powerup():
	if active_powerups.size() == types.size(): return
	
	var type = types[randi() % types.size()]
	
	while _type_is_active(type):
		type = types[randi() % types.size()]
	
	activate_powerup(type.new(player))

func _type_is_active(type):
	for powerup in active_powerups:
		if powerup is type:
			return true
	return false

class Powerup extends Reference:
	var message
	var target_var
	var replacement_value
	var restoring_value
	var duration = 60
	
	func activate(player): player.set(target_var, replacement_value)
	func deactivate(player): player.set(target_var, restoring_value)

class DoubleScorePowerup extends Powerup:
	func _init(player):
		message = "DoubleScore"
		target_var = "score_per_second"
		restoring_value = player.score_per_second
		replacement_value = 2 * restoring_value

class FreeValuePowerup extends Powerup:
	func _init(player):
		message = "FreeValue"
		target_var = "value_ratio"
		restoring_value = player.value_ratio
		replacement_value = player.value_ratio
		duration = 0
	
	func activate(player):
		replacement_value.reset(player.ratio_buffer_size, 0.75)
		.activate(player)

class SpeedBoostPowerup extends Powerup:
	func _init(player):
		message = "SpeedBoost"
		target_var = "move_speed"
		restoring_value = player.move_speed
		replacement_value = restoring_value * 1.5
		duration = 60

class FreeAimPowerup extends Powerup:
	func _init(player):
		message = "FreeAim"
		duration = 60
	
	func activate(player):
		player.get_node("PlayerWeapon").free_aim = true
	
	func deactivate(player):
		player.get_node("PlayerWeapon").free_aim = false

class BulletTimePowerup extends Powerup:
	func _init(player):
		message = "BulletTime"
		duration = 60
	
	func activate(player):
		Engine.time_scale = 0.25
	
	func deactivate(player):
		Engine.time_scale = 1.0

class ImaFirinMaLazorPowerup extends Powerup:
	var weapon
	
	func _init(player):
		weapon = player.get_node("PlayerWeapon")
		message = "FirinMaLazor"
		restoring_value = weapon.firing_rate
		duration = 60
	
	func activate(player):
		weapon.firing_rate = 100
		weapon.spread = 0.5
	
	func deactivate(player):
		weapon.firing_rate = restoring_value
		weapon.spread = 0.1