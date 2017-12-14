extends Sprite

var velocity = Vector2()

export(PoolStringArray) var ignore_groups = []

func _process(delta):
	position += velocity * delta 

func _collided(other_area):
	for group in other_area.get_parent().get_groups():
		if group in ignore_groups: return
	print("%s collided with %s" % [get_name(), other_area.get_parent().get_name()])

func _offscreen():
	queue_free()
