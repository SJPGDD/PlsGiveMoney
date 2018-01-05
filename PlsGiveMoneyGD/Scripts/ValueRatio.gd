extends Reference

#Emitted when the ratio goes below minimum in add_value
signal below_minimum

#Emitted when the ratio goes above maximum in add_value
signal above_maximum

#The set of values being tracked for the ratio
var buffer = []

#The cached sum of the buffer values
var current_sum

#The index to override next time add_value is called
var current_index

#The threshold for emitting below_minimum
var minimum

#The threshold for emitting above_minimum
var maximum

#Stores whether the last added value put the ratio outside of the min/max range
var last_state = 0

#Property for accessing the current ratio
var ratio setget ,_get_ratio

#Constructs a ValueRatio with the minimum (default=0) and
#maximum (default=2), then resets the object to have a buffer
#of length buffer_size, where all the elements in the buffer
#are start_value.
func _init(buffer_size, start_value, minimum = 0, maximum = 2):
	self.minimum = minimum
	self.maximum = maximum
	reset(buffer_size, start_value)

#Overrides the value at current_index in the buffer,
#subtracting it from current_sum, overwriting it,
#then adding that new value to the current sum, before
#moving the index to the next value, and wrapping that index
#to fit within the buffer size. When a value is added, it is
#possible that a boundary has been tripped, so the function
#then calls _check_boundaries to emit a signal if needed.
func add_value(value):
	current_sum -= buffer[current_index]
	buffer[current_index] = value
	current_sum += buffer[current_index]
	current_index = (current_index + 1) % buffer.size()
	
	_check_boundaries()

#Resizes the buffer to the new buffer_size,
#then initializes all indexes to start_value,
#sets current_sum to the sum of the buffer, and
#sets the current_index back to the start of the buffer.
func reset(buffer_size, start_value):
	buffer.resize(buffer_size)
	for i in buffer_size:
		buffer[i] = start_value
	current_sum = buffer_size * start_value
	current_index = 0

#Returns the float ratio, as the current_sum
#divided by the buffer size
func _get_ratio():
	return float(current_sum) / buffer.size()

#Checks if the ratio is above or below
#the maximum or the minimum, and emits
#the corresponding signals if needed.
func _check_boundaries():
	if _get_ratio() <= minimum:
		if last_state != -1:
			emit_signal("below_minimum")
			last_state = -1
	elif _get_ratio() >= maximum:
		if last_state != 1:
			emit_signal("above_maximum")
			last_state = 1
	else:
		last_state = 0
