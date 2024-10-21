extends State

var actorPlayer
var isJumpStarted

func enter(actor):
	isJumpStarted = false
	actorPlayer = actor
	actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.DOUBLE_JUMPING)
	actor.PlayAnim("jump_double")
	
func update(delta, actor):
	StateLogic(actor)
	HandleStateTransition(actor)

func StateLogic(actor):
	actor.ApplyGravity(actor.gravityType.JUMPFALL)
	actor.ApplyAirHMove()
		
func HandleStateTransition(actor):
	if isJumpStarted:
		if !actor.controller.inputJumpPress or actor.velocity.y > 0:
			actor.stateMachine.set_state(get_parent().FALLING)

func HandleDoubleJump():
	isJumpStarted = true	
	actorPlayer.playerAnim.queue("jump_mid")
	actorPlayer.velocity.y = actorPlayer.jumpVelocity * actorPlayer.secondJumpRate
	actorPlayer.jumpCount = actorPlayer.jumpCount - 1	
