extends State

var canGlide
var currentStamina
var staminaCost

func _ready():
	events.connect("player_stamina_changed", OnPlayerStaminaChanged)

func enter(actor):
	staminaCost = actor.stamCostGliding
	canGlide = actor.CheckEnoughStamina(currentStamina,staminaCost)
	if canGlide:
		actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.GLIDING)
		if actor.playerAnim:
			actor.playerAnim.play("fall_mid")
	else:
		actor.controller.inputGlidePress = false
		actor.stateMachine.set_state(get_parent().FALLING)	
	
func update(delta, actor):
	canGlide = actor.CheckEnoughStamina(currentStamina,staminaCost)
	StateLogic(actor)
	HandleStateTransition(actor)

func OnPlayerStaminaChanged(staminaValue, _staminaState):
	currentStamina = staminaValue

func StateLogic(actor):
	if canGlide:
		actor.jumpCount = 0
		actor.velocity.y = actor.glidingGravity
		actor.velocity.x = actor.controller.movementVector * actor.glidingMoveSpeed
		actor.stamina.Drain(staminaCost * get_physics_process_delta_time())

func HandleStateTransition(actor):
	if actor.controller.inputJumpPressStart or !actor.controller.inputGlidePress or !canGlide:
		actor.stateMachine.set_state(get_parent().FALLING)
	
	if actor.is_on_floor():
		actor.jumpCount = actor.maxJumpCount
		actor.playerAnim.play("landing")
		actor.stateMachine.set_state(get_parent().IDLE)
