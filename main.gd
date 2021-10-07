extends Node2D

onready var mob = preload("res://Enemies/mob.tscn")

var instance

var building = false

var wave = 0
var mobs_remaining = 0
var wave_mobs = [5, 15, 20]


func _ready():
	$wave_timer.start()
	mobs_remaining = 5


func _on_mob_timer_timeout():
	instance = mob.instance()
	$Path2D.add_child(instance)
	mobs_remaining -= 1
	if mobs_remaining <= 0:
		$mob_timer.stop()
		wave += 1
		if wave  < len(wave_mobs):
			$wave_timer.start()


func _on_wave_timer_timeout():
	mobs_remaining = wave_mobs[wave]
	$mob_timer.start()
	$wave_timer.stop()
