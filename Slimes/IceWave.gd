extends Area2D


var damage


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Wave")

func _on_AnimatedSprite_animation_finished():
	queue_free()
