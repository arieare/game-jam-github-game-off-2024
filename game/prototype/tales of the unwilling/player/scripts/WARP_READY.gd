extends State

func enter(actor):
	actor.currentWarpingState = actor.abilityWarpStates.WARP_READY
	events.emit_signal("player_ability_warping_state_changed", actor.abilityWarpStates.keys()[actor.currentWarpingState])
	pass

func update(delta, actor):	
	#State Transitions
	HandleStateTransition(actor)
	pass

func exit(_actor):
	pass

func HandleStateTransition(actor):
	if actor.controller.inputWarpPressStart:
		actor.abilityStateMachine.set_state(get_parent().WARP_SCANNING) 
	
