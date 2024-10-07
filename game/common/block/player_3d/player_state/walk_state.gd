# Walk class_state
extends class_state

var WALK_SPEED:float = 8
var ACCELERATION:float = 64

func enter_state() -> void:
	super()
	print(state_machine_parent.current_state.name)

func process_input(event: InputEvent) -> class_state:
	return null

func process_physics(delta: float) -> class_state:
	var direction
	#if actor.root.cam:
		#direction = (actor.root.cam.global_basis * actor.player_input.get_direction()).normalized()	
	#else:
	direction = actor.player_input.get_direction()
	walk(direction, delta, actor)
	
	if actor.player_input.get_direction() == Vector3.ZERO and actor.position_state_machine.current_state.name == "on_ground" and actor.linear_velocity.x < 8 and actor.linear_velocity.z < 8:
		return state_machine_parent.state_list["idle"]
	if actor.player_input.want_to_jump() and actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_list["jump"]	
		
				
	if actor.skill_state_machine.current_state.name == "range" and actor.skill_state_machine.current_state.current_projectile != null and actor.player_input.want_to_warp():
		return state_machine_parent.state_list["warp"]	
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
	
	if actor.root.bob_sine.cycle(delta, frequence, amplitude) < - amplitude + 0.1:
		var tween_right_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_right_arm.tween_property(actor.body_right_arm,"position:z", scale ,0.1)
		
		var tween_left_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_left_arm.tween_property(actor.body_left_arm,"position:z", - scale , 0.2)		
	
	if actor.root.bob_sine.cycle(delta, frequence, amplitude) > amplitude - 0.1:		
		var tween_left_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_left_arm.tween_property(actor.body_left_arm,"position:z", scale , 0.1)		

		var tween_right_arm = create_tween().set_trans(Tween.TRANS_SINE)
		tween_right_arm.tween_property(actor.body_right_arm,"position:z", -scale ,0.2)

#func animate_feet_walk(delta, scale):
	
