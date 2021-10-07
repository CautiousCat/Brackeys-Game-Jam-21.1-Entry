extends Area2D

signal dragging(current_pos, previous_pos)
signal released

var previous_mouse_position = Vector2()
var is_dragging = false
var can_drag = false


func _on_DragArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_touch") and can_drag:
		get_tree().set_input_as_handled()
		previous_mouse_position = get_viewport().get_mouse_position()
		is_dragging = true
	

func _input(event):
	if not is_dragging:
		return
	
	if event.is_action_released("ui_touch") and is_dragging:
		previous_mouse_position = Vector2.ZERO
		is_dragging = false
		can_drag = false
		emit_signal("released")
		
	if is_dragging and event is InputEventMouseMotion:
		emit_signal("dragging", get_viewport().get_mouse_position(), previous_mouse_position)
		previous_mouse_position = get_viewport().get_mouse_position()
