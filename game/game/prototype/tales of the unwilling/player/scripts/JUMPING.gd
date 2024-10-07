extends State

var actorPlayer
var isJumpStarted

func enter(actor):
	isJumpStarted = false
	actorPlayer = actor
	actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.JUMPING) 
	actor.PlayAnim("jump_start")

func update(delta, actor):
	StateLogic(actor)
	HandleStateTransition(actor)
	
func StateLogic(actor):
	actor.ApplyGravity(actor.gravityType.JUMPFALL)
	actor.ApplyAirHMove()

func HandleStateTransition(actor):
	if actor.controller.inputDashPressStart and actor.controller.currentInput == actor.controller.inputStates.INPUT_DASHING:
		if actor.controller.inputMoveDownPress:
			actor.stateMachine.set_state(get_parent().POUNDING)
		else:	
			actor.stateMachine.set_state(get_parent().DASHING)
	
	if isJumpStarted:
		if actor.controller.inputJumpPressStart and actor.jumpCount > 0:
			actor.stateMachine.set_state(get_parent().JUMP_DOUBLE)
		elif !actor.controller.inputJumpPress or actor.velocity.y > 0:
				actor.stateMachine.set_state(get_parent().FALLING)

func HandleJumping():
	isJumpStarted = true
	actorPlayer.playerAnim.play("jump_mid")
	actorPlayer.velocity.y = actorPlayer.jumpVelocity
	actorPlayer.jumpCount = actorPlayer.jumpCount - 1
