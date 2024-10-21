extends State

var isPounding
var canPound
var currentStamina
var staminaCost
var actorPlayer

func _ready():
	events.connect("player_stamina_changed", OnPlayerStaminaChanged)

func enter(actor):
	staminaCost = actor.stamCostPound
	canPound = actor.CheckEnoughStamina(currentStamina, staminaCost)
	if not canPound:
		actor.stateMachine.set_state(get_parent().FALLING)
	else:
		isPounding = false
		actorPlayer = actor
		actor.velocity.x = 0
		actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.POUNDING)
	
func update(delta, actor):
	if not isPounding:
		actor.playerAnim.play("fall_mid")
		Pounding(actor, actor.poundSpeed, actor.poundDuration, delta)
	
func exit(actor):
	actor.ChangeAndEmitPreviousPlayerState(actor.currentState)

func Pounding(actor, speed, duration, delta):
	isPounding = true
	actor.stamina.Drain(staminaCost) #instantly drain
	actor.velocity.y += speed * delta
	actor.velocity.x = 0
	if actor.is_on_floor() or actor.playerAnim.current_animation != "landing_pound":
		globalFunc.FlashSprite(actor.playerSprite,Vector3(1, 1, 1),1)
		actor.playerAnim.play("landing_pound")
	

func HandlePoundBounce():
	isPounding = false
	actorPlayer.playerAnim.play("jump_mid")
	globalFunc.FlashSprite(actorPlayer.playerSprite,Vector3(1, 1, 1),0)
	actorPlayer.velocity.y = actorPlayer.jumpVelocity * actorPlayer.poundBounceRate
	actorPlayer.velocity.x = actorPlayer.controller.movementVector * (actorPlayer.joggingSpeed * 0.75)
	
	if actorPlayer.velocity.y <= 0:
		actorPlayer.stateMachine.set_state(get_parent().FALLING)
	
func OnPlayerStaminaChanged(staminaValue, _staminaState):
	currentStamina = staminaValue
