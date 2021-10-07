extends Node2D


onready var GreenSlime = preload("res://Slimes/GreenSlime.tscn")
onready var MediumGreenSlime = preload("res://Slimes/MediumGreenSlime.tscn")
onready var BlueSlime = preload("res://Slimes/BlueSlime.tscn")

export var maxSlimes = 10
var slimeAmount = 0

var Bound1
var Bound2

var maxBoundary := Vector2()
var minBoundary := Vector2()

func _ready():
	Bound1 = get_tree().get_nodes_in_group("bound1")
	Bound2 = get_tree().get_nodes_in_group("bound2")
	minBoundary = Bound1[0].position
	maxBoundary = Bound2[0].position
	$SlimeSpawnTimer.wait_time = 2
	$SlimeSpawnTimer.start()

func _on_SlimeSpawnTimer_timeout():
	slimeAmount = get_tree().get_nodes_in_group("slime").size()
	print(slimeAmount)
	if slimeAmount < maxSlimes:
		var spawnPosition = Vector2()
		spawnPosition.x = rand_range(minBoundary.x, maxBoundary.x)
		spawnPosition.y = rand_range(minBoundary.y, maxBoundary.y)
		var main = get_tree().current_scene
		var instance
		match floor(rand_range(1, 3)):
			1.0:
				instance = GreenSlime.instance()
			2.0:
				instance = BlueSlime.instance()
		main.add_child(instance)
		instance.position = spawnPosition
		slimeAmount += 1
