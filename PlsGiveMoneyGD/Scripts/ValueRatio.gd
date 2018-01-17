extends Reference

#Emitted when the ratio goes below minimum in add_value
signal below_minimum

#Emitted when the ratio goes above maximum in add_value
signal above_maximum

#Emitted when the ratio goes below -0.5
signal low_warning

#The cached sum of the buffer values
var current_sum

#The threshold for emitting below_minimum
var minimum

#The threshold for emitting above_minimum
var maximum

var divisor

#Stores whether the last added value put the ratio outside of the min/max range
var last_state = 0

#Property for accessing the current ratio
var ratio setget ,_get_ratio

func _init(divisor, start_value, minimum = 0, maximum = 2):
	self.minimum = minimum
	self.maximum = maximum
	self.divisor = divisor
	reset(divisor, start_value)

func add_value(value):
	current_sum = clamp(current_sum + value, divisor * minimum, divisor * maximum)
	_check_boundaries()

func reset(divisor, start_value):
	current_sum = divisor * start_value

#Returns the float ratio, as the current_sum
#divided by the buffer size
func _get_ratio():
	return round(current_sum) / divisor

#Checks if the ratio is above or below
#the maximum or the minimum, and emits
#the corresponding signals if needed.
func _check_boundaries():
	if _get_ratio() <= minimum:
		if last_state != -2:
			emit_signal("below_minimum")
			last_state = -2
	elif _get_ratio() <= -0.5:
		if last_state != -1:
			emit_signal("low_warning")
			last_state = -1
	elif _get_ratio() >= maximum:
		if last_state != 1:
			emit_signal("above_maximum")
			last_state = 1
	elif _get_ratio() >= 0.0:
		if last_state != 0:
			last_state = 0
