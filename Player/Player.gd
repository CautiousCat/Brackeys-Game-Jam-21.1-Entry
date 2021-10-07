extends KinematicBody2D


export var MAX_SPEED := 200
export var ACCELERATION := 1200
export var FRICTION := 800

var _vector_input := Vector2.ZERO
var _velocity := Vector2.ZERO

func _physics_process(delta):
	player_input()
	move_player(delta)


func player_input() -> void:
	_vector_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_vector_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_vector_input = _vector_input.normalized()	


func move_player(delta):
	if _vector_input != Vector2.ZERO:
		_velocity = _velocity.move_toward(_vector_input * MAX_SPEED, ACCELERATION * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide(_velocity)
