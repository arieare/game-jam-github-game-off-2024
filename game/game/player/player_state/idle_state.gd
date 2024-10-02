# Idle State
extends State

func enter_state() -> void:
	var tween_arm_right = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var tween_arm_left = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_arm_right.tween_property(actor.body_right_arm,"position",actor.target_default_right_arm.position,0.05)
	tween_arm_left.tween_property(actor.body_left_arm,"position",actor.target_default_left_arm.position,0.05)	
	super()	

	

func process_input(event: InputEvent) -> State:
	if root.common["input_map"].want_to_jump() and actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_dictionary["jump"]
	if root.common["input_map"].get_direction() != Vector3.ZERO and actor.position_state_machine.current_state.name == "on_ground":
		return state_machine_parent.state_dictionary["walk"]

	return null

func process_physics(delta: float) -> State:
	actor.body.rotation_degrees.x = lerpf(actor.body.rotation_degrees.x,0,0.1)
	actor.linear_velocity.x = lerpf(actor.linear_velocity.x,0,0.1)
	actor.linear_velocity.z = lerpf(actor.linear_velocity.z,0,0.1)
	
	animate_breathe_idle(delta, 0.07)	
	
	if actor.skill_state_machine.current_state.name == "range" and actor.skill_state_machine.current_state.current_projectile != null and root.common["input_map"].want_to_warp():
		return state_machine_parent.state_dictionary["warp"]	
	
	return null


func animate_breathe_idle(delta, scale):
	var frequence = 2.5 # sin speed 2.5
	var amplitude = 1.0 # value range=
	if root.common["bob_sine"].cycle(delta, frequence, amplitude) < - amplitude + 0.1: #left
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(actor.body_torso,"position:y",actor.body_torso.position.y - scale,0.3)
		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(actor.body_head,"position:y",actor.body_head.position.y - scale,0.5)		
	if root.common["bob_sine"].cycle(delta, frequence, amplitude) > amplitude - 0.1: #right	
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(actor.body_torso,"position:y",actor.body_torso.position.y + scale,0.3)
		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(actor.body_head,"position:y",actor.body_head.position.y + scale,0.5)	
