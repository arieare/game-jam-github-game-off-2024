extends State

func enter(actor):
	if actor.bowSprite:
		actor.bowSprite.set_frame(0)
	actor.ChangeAndEmitCurrentWeaponState(actor.weaponBowStates.READY)

func update(delta, actor):
	actor.ResetBowRotation(delta)
	
	#State Transitions
	if actor.inputShootPressStart:
		actor.stateMachine.set_state(get_parent().DRAW) 

func exit(actor):
	pass
