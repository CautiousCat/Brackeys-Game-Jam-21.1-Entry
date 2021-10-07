extends Area2D


func is_occupied() -> bool:
	var areas = get_overlapping_areas()
	if areas.size() > 1:
		return true
	return false
	
	
