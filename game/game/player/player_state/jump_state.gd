# Jump State
extends State

func enter_state() -> void:
	super()
	print(state_machine_parent.current_state.name)
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(actor.skin,"scale:y",1.5,0.1)
	tween.tween_property(actor.skin,"scale:z",1,0.1)	
	actor.apply_central_impulse(Vector3.UP * 12 * actor.mass)	

func process_input(event: InputEvent) -> State:
	if actor.player_input.want_to_jump():
		return state_machine_parent.state_dictionary["fall"]
	return null

func process_physics(delta: float) -> State:
	#var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	#tween.tween_property(actor.skin,"scale:y",1.0,0.5)
	if actor.linear_velocity.y <= 9 and actor.position_state_machine.current_state.name == "on_air":
		return state_machine_parent.state_dictionary["fall"]
	return null
