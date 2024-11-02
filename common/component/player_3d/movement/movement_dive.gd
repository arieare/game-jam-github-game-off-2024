extends Node

var parent: RigidBody3D

var MAX_DIVING_TIME: float = 2.0
var REBOUND_FORCE: float = 80.0
var diving_time: float = MAX_DIVING_TIME
var diving_time_decay = 0.1
var is_in_water:bool = false
var is_diving: bool = false

func assert_parent(parent_node: RigidBody3D):
	parent = parent_node
	
func dive(delta):
	var dive_force = REBOUND_FORCE + 1
	var rebound_force = REBOUND_FORCE
	
	if is_in_water:
		parent.apply_central_impulse(-parent.linear_velocity * delta)
		if parent.current_ability != parent.ABILITY.SALMON:
			rebound_force = rebound_force/2
			if parent.root.current_game_state != parent.root.GAME_STATE.OVER:
				parent.apply_force(-Vector3.RIGHT * (dive_force/5))
		else:
			parent.apply_force(Vector3.RIGHT * (dive_force))
		if parent.root.current_game_state != parent.root.GAME_STATE.OVER:
			parent.apply_force(Vector3.UP * rebound_force)
				
		if Input.is_action_pressed("jump") and diving_time > 0:
			if parent.current_ability == parent.ABILITY.SALMON:
				dive_force = REBOUND_FORCE * 2		
				parent.apply_impulse(Vector3.RIGHT * (dive_force/25))
				parent.apply_force(Vector3.DOWN * (dive_force))

				parent.body.rotation.x = 180
				diving_time -= diving_time_decay
				parent.root.dive_meter_value = diving_time/MAX_DIVING_TIME*100
	if !is_in_water:
		parent.body.rotation.x = 0
		if diving_time < MAX_DIVING_TIME:
			diving_time += diving_time_decay * 2
			parent.root.dive_meter_value = diving_time/MAX_DIVING_TIME*100

func set_diving_time_value(value: float):
	diving_time = value
	parent.root.dive_meter_value = value/MAX_DIVING_TIME*100
