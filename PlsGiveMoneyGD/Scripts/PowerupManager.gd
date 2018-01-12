extends Node2D

onready var player = $"/root/Game/Player"
onready var messages = $"/root/Game/Messages"

var active_powerups = []

func _ready():
	player.connect("reached_powerup", self, "_choose_random_powerup")

func _process(delta):
	_consume_durations(delta)

func activate_powerup(powerup):
	powerup.activate(player)
	active_powerups.append(powerup)
	messages.show(powerup.message)
	AudioServer.set_bus_effect_enabled(1, 0, true)

func deactivate_powerup(powerup):
	powerup.deactivate(player)
	active_powerups.erase(powerup)
	AudioServer.set_bus_effect_enabled(1, 0, false)

func _consume_durations(delta):
	for powerup in active_powerups:
		powerup.duration -= delta
		if powerup.duration <= 0:
			deactivate_powerup(powerup)

func _choose_random_powerup():
	var types = [DoubleScorePowerup, FreeValuePowerup]
	activate_powerup(types[randi() % types.size()].new(player))

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