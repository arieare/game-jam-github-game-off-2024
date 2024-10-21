extends State

var actorPlayer

func enter(actor):
	actorPlayer = actor
	actor.velocity.y = lerpf(actor.velocity.y, 0, actor.jumpCutRate) # Jump Cut
	actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.FALLING)
	actor.PlayAnim("fall_start")
	
func update(delta, actor):
	#State Logic
	actor.ApplyGravity(actor.gravityType.JUMPFALL)
	if actor.velocity.y > 0:
		actor.velocity.y += actor.fallGravity * delta
		if actor.playerAnim and not actor.is_on_floor():
			actor.playerAnim.play("fall_mid")	
	
#	if actor.velocity.x == 0:
#		actor.velocity.x = actor.controller.playerMovingDirection * (actor.joggingSpeed)
#	else:
	actor.velocity.x = actor.controller.movementVector * (actor.joggingSpeed * 0.75)
	
	#State Transitions
	HandleStateTransition(actor)


func HandleStateTransition(actor):
	if actor.is_on_floor() and actor.playerAnim.current_animation != "landing":
		actor.velocity.x = 0
		actor.jumpCount = actor.maxJumpCount
		actor.playerAnim.play("landing")
	
	if actor.controller.inputJumpPressStart and actor.jumpCount == actor.maxJumpCount:
		actor.stateMachine.set_state(get_parent().JUMPING)

	if actor.controller.inputJumpPressStart and actor.jumpCount > 0 and actor.jumpCount < actor.maxJumpCount:
		actor.stateMachine.set_state(get_parent().JUMP_DOUBLE)		
	
	if actor.controller.inputGlidePress and actor.controller.currentInput == actor.controller.inputStates.INPUT_GLIDING:
		actor.stateMachine.set_state(get_parent().GLIDING)
	
	if actor.controller.inputDashPressStart and actor.controller.currentInput == actor.controller.inputStates.INPUT_DASHING:
		if actor.controller.inputMoveDownPress:
			actor.stateMachine.set_state(get_parent().POUNDING)
		else:	
			actor.stateMachine.set_state(get_parent().DASHING)	

func SetIdleState():
	actorPlayer.stateMachine.set_state(get_parent().IDLE)
	
