extends PathFollow2D

onready var HealthBar := load("res://Enemies/HealthBar.tscn")

var speed := 60
var maxhp := 10.0
var hp := 0.0 setget set_hp
var healthBar
var damagedByIce = false

func _ready():
	hp = maxhp
	healthBar = HealthBar.instance()
	var main = get_tree().current_scene
	main.add_child(healthBar)


func _physics_process(delta):
	offset += speed * delta
	
	if unit_offset >= 1:
		reached_end()
		
	healthBar.rect_position = position


func reached_end():
	healthBar.queue_free()
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		area.queue_free()
		self.hp -= area.damage
		healthBar.get_child(0).value = (hp/maxhp) * healthBar.get_child(0).max_value
	if area.is_in_group("ice_wave"):
		speed = 30
		if !damagedByIce:
			self.hp -= area.damage
			healthBar.get_child(0).value = (hp/maxhp) * healthBar.get_child(0).max_value
			$SlowDownTimer.start()
			damagedByIce = true


func set_hp(value):
	hp = value
	if hp <= 0:
		healthBar.queue_free()
		queue_free()


func _on_SlowDownTimer_timeout():
	speed = 60
	damagedByIce = false


func _on_Area2D_area_exited(area):
	if area.is_in_group("ice_wave"):
		damagedByIce = false
