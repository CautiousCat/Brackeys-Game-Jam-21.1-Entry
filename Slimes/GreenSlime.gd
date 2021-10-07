extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_tree().current_scene
	var slime = load("res://Slimes/MediumGreenSlime.tscn").instance()
	main.add_child(slime)
	print(global_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
