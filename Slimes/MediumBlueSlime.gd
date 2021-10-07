extends KinematicBody2D

onready var SlimeToSpawn := preload("res://Slimes/MediumGreenSlime.tscn")
onready var Bullet := preload("res://Slimes/IceWave.tscn")

onready var stateTimer := get_node("StateTimer")
onready var dragArea := get_node("Overlaps/DragArea")
onready var slimeDetector := get_node("Overlaps/SlimeDetector")
onready var towerMarkDetector := get_node("Overlaps/TowerMarkDetector")
onready var enemyDetector := get_node("Overlaps/EnemyDetector")

export var MAX_SPEED := 50
export var ACCELERATION := 800
export var FRICTION := 400
export var STATE_DURATION := 1
export var DAMAGE := 2

enum {IDLE, WANDER, TURRET}

var _state := IDLE
var _states

var _destination := Vector2.ZERO
var _directionVector := Vector2.ZERO
var _velocity := Vector2.ZERO
var _maxBoundary := Vector2(360, 272)
var _minBoundary := Vector2(0, 168)

var _justReleased := false
var _turretMode := false

var _enemies := []
var _current_target = null
var distance_to_t 
var radius = 48
var target_position

func _ready():
	dragArea.connect("dragging", self, "on_drag")
	dragArea.connect("released", self, "on_released")
	
	_states = [IDLE, WANDER]
	_state = WANDER
	_destination.x = rand_range(global_position.x-100, global_position.x+100)
	_destination.y = rand_range(global_position.y-100, global_position.y+100)
	stateTimer.wait_time = STATE_DURATION
	stateTimer.start()


func _physics_process(delta):
	match _state:
		IDLE:
			pass
		WANDER:
			_directionVector = global_position.direction_to(_destination)
			_velocity = _velocity.move_toward(_directionVector * MAX_SPEED, ACCELERATION * delta)
			_velocity = move_and_slide(_velocity)
			
			if global_position.distance_to(_destination) < 5:
				_state = IDLE
			
			clamp_position()
		TURRET:
			var towerMark = towerMarkDetector.on_tower_mark()
			if towerMark != null and _justReleased:
				if !towerMark.is_occupied:
					position = towerMark.global_position
					_turretMode = true
					enemyDetector.visible = true
					$Position2D.visible = true
					stateTimer.stop()
			elif towerMark == null and _justReleased and _turretMode:
				queue_free()
				
			if _turretMode:
				if !_current_target: #If no target
					seek_nearest_enemy()
					if _current_target:
						$FireTimer.start()
				else:				#If there is target
					if (!_current_target.get_ref()):	#If target just died or out of reach
						_current_target = null
						$FireTimer.stop()
					else:								#If target is alive and in reach
						seek_nearest_enemy()
						target_position = _current_target.get_ref().get_global_transform().origin
						$Position2D.rotation = (target_position - position).angle()
						

	if !_turretMode and _justReleased:
		clamp_position()
		if slimeDetector.can_combine_slimes():
			combine()
	_justReleased = false


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_StateTimer_timeout():
	if !_turretMode:
		_state = pick_random_state(_states)
	if _state == WANDER:
		_destination.x = rand_range(global_position.x-100, global_position.x+100)
		_destination.y = rand_range(global_position.y-100, global_position.y+100)
	_states = [IDLE, WANDER]


func on_drag(current_pos, previous_pos):
	global_position += current_pos - previous_pos
	_state = TURRET
	enemyDetector.visible = false
	stateTimer.stop()


func combine():
	var main = get_tree().current_scene
	var slimeToSpawn = SlimeToSpawn.instance()
	main.add_child(slimeToSpawn)
	slimeToSpawn.global_position = global_position
	slimeDetector.remove_slimes()
	queue_free()


func on_released():
	_justReleased = true
	stateTimer.start()


func clamp_position():
	position.x = clamp(position.x, _minBoundary.x, _maxBoundary.x)
	position.y = clamp(position.y, _minBoundary.y, _maxBoundary.y)	


func seek_nearest_enemy():
	distance_to_t = radius + 1
	for target in _enemies:
		if ((position - target.get_global_transform().origin).length() < distance_to_t):
			_current_target = weakref(target)
			target_position = target.get_global_transform().origin
			distance_to_t = (position - target_position).length()


func shoot_bullet():
	if _current_target.get_ref():
		var bullet = Bullet.instance()
		bullet.position = $Position2D/Position2D.global_position
		bullet.damage = DAMAGE
		get_parent().add_child(bullet)


func _on_EnemyDetector_area_entered(area):
	if _turretMode:
		_enemies.append(area.get_parent())


func _on_EnemyDetector_area_exited(area):
	if _turretMode:
		_enemies.erase(area.get_parent())
		if _current_target != null:
			if area.get_parent() == _current_target.get_ref():
				_current_target = null
				$FireTimer.stop()


func _on_FireTimer_timeout():
	shoot_bullet()
		
