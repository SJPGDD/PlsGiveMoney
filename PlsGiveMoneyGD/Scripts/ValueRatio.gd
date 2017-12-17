extends Reference

signal below_minimum
signal above_maximum

var buffer = []
var current_sum
var current_index
var minimum
var maximum

var ratio setget ,_get_ratio

func _init(buffer_size, start_value, minimum = 0, maximum = 2):
	self.minimum = minimum
	self.maximum = maximum
	reset(buffer_size, start_value)

func add_value(value):
	current_sum -= buffer[current_index]
	buffer[current_index] = value
	current_sum += buffer[current_index]
	current_index = (current_index + 1) % buffer.size()
	
	_check_boundaries()

func reset(buffer_size, start_value):
	buffer.resize(buffer_size)
	for i in buffer_size:
		buffer[i] = start_value
	current_sum = buffer_size * start_value
	current_index = 0

func _get_ratio():
	return float(current_sum) / buffer.size()

func _check_boundaries():
	if _get_ratio() < minimum: 
		emit_signal("below_minimum")
	elif _get_ratio() > maximum:
		emit_signal("above_maximum")
