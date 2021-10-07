extends Area2D


export var damage = 2

var target = null
var speed = 200
var velocity

func _physics_process(delta):
	if target.get_ref():
		velocity = (target.get_ref().get_global_transform().origin - position).normalized() * speed
		position += velocity * delta
	else:
		queue_free()
		
func set_target(new_target):
	target = weakref(new_target)
