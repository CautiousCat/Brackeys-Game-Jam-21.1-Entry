extends Area2D


var is_occupied := false

func _process(delta):
	is_occupied = $CheckTower.is_occupied()
