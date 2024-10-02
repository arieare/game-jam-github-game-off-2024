# Walk State
extends State

var WALK_SPEED:float = 10
var ACCELERATION:float = 64



func enter_state() -> void:
	super()
	print(state_machine_parent.current_state.name)

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	
	var direction
	direction = (actor.root.cam.global_basis * root.common["input_map"].get_direction()).normalized()	
	walk(direction, delta, actor)
	
	if root.common["input_map"].get_direction() == Vector3.ZERO and actor.position_state_machine.current_state.name == "on_ground" and actor.linear_velocity.x < 8 and actor.linear_velocity.z < 8:
		return state_machine_parent.state_dictionary["idle"]
	if root.common["input_map"].want_to_jump() and actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_dictionary["jump"]	
		
				
	if actor.skill_state_machine.current_state.name == "range" and actor.skill_state_machine.current_state.current_projectile != null and root.common["input_map"].want_to_warp():
		return state_machine_parent.state_dictionary["warp"]	
	return null

func exit_state() -> void:
	super()
	actor.running_dust_vfx.emitting = false	
	var tween_arm_right = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var tween_arm_left = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_arm_right.tween_property(actor.body_right_arm,"position",actor.target_default_right_arm.position,0.05)
	tween_arm_left.tween_property(actor.body_left_arm,"position",actor.target_default_left_arm.position,0.05)		

func walk(direction, delta, actor):
	var horizontal_velocity = actor.linear_velocity * Vector3(1, 0, 1)
	var target_velocity: Vector3 = (direction * WALK_SPEED)
	var acceleration_goal = target_velocity - horizontal_velocity	
	var target_acceleration = acceleration_goal / delta
	
	# clamp ForceToGoalAcceleration to our maximum allowed acceleration.
	if target_acceleration.length() > ACCELERATION: 
		target_acceleration = (target_acceleration.normalized() * ACCELERATION)
	
	var leaning_point: Vector3 = Vector3(0, -0.8, 0)
	actor.apply_force(target_acceleration * actor.mass, leaning_point)


	actor.running_dust_vfx.emitting = true	
	actor.body.rotation_degrees.x = lerpf(actor.body.rotation_degrees.x,-15,0.5)
	animate_hand_walk(delta, 0.3)	
	

func animate_hand_walk(delta, scale):
	var frequence = WALK_SPEED/2 # sin speed 2.5
	var amplitude = 1.0 # value range
	
	if actor.root.common["bob_sine"].cycle(delta, frequence, amplitude) < - amplitude + 0.1:
		var tween_right_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_right_arm.tween_property(actor.body_right_arm,"position:z", scale ,0.1)
		
		var tween_left_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_left_arm.tween_property(actor.body_left_arm,"position:z", - scale , 0.2)		
	
	if actor.root.common["bob_sine"].cycle(delta, frequence, amplitude) > amplitude - 0.1:		
		var tween_left_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_left_arm.tween_property(actor.body_left_arm,"position:z", scale , 0.1)		

		var tween_right_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_right_arm.tween_property(actor.body_right_arm,"position:z", -scale ,0.2)

#func animate_feet_walk(delta, scale):
	
