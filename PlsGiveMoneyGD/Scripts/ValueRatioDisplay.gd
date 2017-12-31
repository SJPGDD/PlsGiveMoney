extends TextureRect

#Property for the ratio point of the attached shader material
var ratio setget _set_ratio,_get_ratio

#Returns the current value of the ratio shader param
func _get_ratio():
	return material.get_shader_param("ratio")

#Sets the ratio shader param to the new value
func _set_ratio(ratio):
	material.set_shader_param("ratio", ratio)