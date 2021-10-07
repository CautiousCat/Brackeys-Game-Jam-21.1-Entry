extends Area2D

var areas


func _input(event):
	if event is InputEventMouseMotion:
		global_position = get_viewport().get_mouse_position()
	
	if can_drag() and event.is_action_pressed("ui_touch"):
		areas[0].can_drag = true


func can_drag() -> bool:
	areas = get_overlapping_areas()
	if areas.size() > 0:
		return true
	return false
