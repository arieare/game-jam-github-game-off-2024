extends State

var actorPlayer
var coyoteWaiting: bool

func enter(actor):
	actorPlayer = actor
	actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.JOGGING)
	actor.PlayAnim("jog")

func update(_delta, actor):
	StateLogic(actor)
	HandleStateTransition(actor)

func StateLogic(actor):
	actor.ApplyGravity(actor.gravityType.WORLD)
	Accelerate(actor, actor.joggingSpeed)

func HandleStateTransition(actor):
	if actor.controller.movementVector == 0: 
		AddFriction(actor)
		if actor.velocity.x == 0:
			actor.stateMachine.set_state(get_parent().IDLE)
	
	if actor.controller.inputJumpPressStart:
		actor.stateMachine.set_state(get_parent().JUMPING)
	
	if actor.controller.inputDashPressStart and actor.controller.currentInput == actor.controller.inputStates.INPUT_DASHING:
		actor.stateMachine.set_state(get_parent().DASHING) 
		
	if not actor.is_on_floor() and not coyoteWaiting:
		actor.ApplyGravity(actor.gravityType.JUMPFALL)
		actor.coyoteTimer.start()
		coyoteWaiting = true
		
func Accelerate(actor, speed):
	var direction = Vector2(actor.playerFacingDirection, 0)
	actor.velocity = actor.velocity.move_toward(speed * direction, actor.acceleration)
	
func AddFriction(actor):
	actor.velocity = actor.velocity.move_toward(Vector2.ZERO, actor.friction)

func _on_coyote_timer_timeout():
	print("coyote timer off")
	coyoteWaiting = false
	actorPlayer.jumpCount = actorPlayer.jumpCount - 1	
	actorPlayer.stateMachine.set_state(get_parent().FALLING) 
	
