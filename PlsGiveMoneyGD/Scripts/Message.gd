extends Position2D

var approach_position = Vector2(0, 0)
var approach_speed = 0.1
var approach_cutoff = 1.0
var wait_duration = 2.0
var depart_scale = Vector2(2, 2)
var depart_speed = 0.1
var depart_cutoff = 0.1

enum MoveState {
	APPROACH, WAIT, DEPART
}

var move_state = MoveState.APPROACH
var waited = 0.0

func _ready():
	$Text.rect_position -= $Text.rect_size / 2

func _process(delta):
	match move_state:
		MoveState.APPROACH:
			position.x = lerp(position.x, approach_position.x, 0.1)
			position.y = lerp(position.y, approach_position.y, 0.1)
			if (position - approach_position).length() <= approach_cutoff:
				move_state = MoveState.WAIT; return
		MoveState.WAIT:
			waited += delta
			if waited >= wait_duration:
				move_state = MoveState.DEPART; return
		MoveState.DEPART:
			scale.x = lerp(scale.x, depart_scale.x, depart_speed)
			scale.y = lerp(scale.y, depart_scale.y, depart_speed)
			modulate.a = lerp(modulate.a, 0, depart_speed)
			if (scale - depart_scale).length() <= depart_cutoff:
				queue_free()