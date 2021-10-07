extends Area2D

export(String) var groupName 
var areas := []

func can_combine_slimes() -> bool:
	areas = get_overlapping_areas()
	var same := 0
	if areas != null:
		for area in areas:
			if area.is_in_group(groupName):
				same += 1
	return areas.size() > 2 and same > 2


func remove_slimes() -> void:
	var i = 0
	for area in areas:
		if i < 3:
			if area.is_in_group(groupName):
				area.get_parent().get_parent().queue_free()
				i += 1
