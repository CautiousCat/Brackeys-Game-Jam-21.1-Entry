extends Area2D

func on_tower_mark():
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		return areas[0]
	return null
