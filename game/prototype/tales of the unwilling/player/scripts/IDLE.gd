extends State

func enter(actor):
	actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.IDLE)
	actor.PlayAnim("idle")

func update(_delta, actor):
	StateLogic(actor)
	HandleStateTransition(actor)

func StateLogic(actor):
	actor.ApplyGravity(actor.gravityType.WORLD)
	if actor.canStaminaRefill:
		actor.stamina.Rejuvenate(actor.stamina.refillRate * get_physics_process_delta_time())	

func HandleStateTransition(actor):
	if not actor.is_on_floor():
		actor.stateMachine.set_state(get_parent().FALLING) 
		
	if actor.controller.inputJumpPress and actor.jumpCount == actor.maxJumpCount:
		actor.stateMachine.set_state(get_parent().JUMPING) 
	
	if actor.controller.movementVector != 0:
		actor.stateMachine.set_state(get_parent().JOGGING)
	
	if actor.controller.inputDashPressStart and actor.controller.currentInput == actor.controller.inputStates.INPUT_DASHING:
		actor.stateMachine.set_state(get_parent().DASHING)
	
