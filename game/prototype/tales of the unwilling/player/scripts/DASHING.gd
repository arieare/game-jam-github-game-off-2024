extends State

var dashSpeed
var isDashing
var canDash
var currentStamina
var staminaCost


func _ready():
	events.connect("player_stamina_changed", OnPlayerStaminaChanged)

func enter(actor):
	staminaCost = actor.stamCostDash
	canDash = actor.CheckEnoughStamina(currentStamina, staminaCost)
	actor.velocity.y = 0
	actor.velocity.x = 0
	if canDash:
		isDashing = false
		actor.playerAnim.play("dashing")
	
func update(delta, actor):
			
	if not isDashing:
		if actor.is_on_floor():
			dashSpeed = actor.groundDashSpeed
			actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.GROUND_DASHING)
		else:
			dashSpeed = actor.airDashSpeed
			actor.ChangeAndEmitCurrentPlayerState(actor.playerStates.AIR_DASHING)
		
		Dashing(actor, dashSpeed, actor.dashDuration, delta)
		
func exit(actor):
	actor.ChangeAndEmitPreviousPlayerState(actor.currentState)

func Dashing(actor, speed, duration, delta):
	if canDash:
		isDashing = true
#		globalFunc.FlashSprite(actor.playerSprite,Vector3(1, 0, 0),0.75)
		actor.stamina.Drain(staminaCost) #instantly drain
		actor.velocity.x += speed * delta * actor.transform.x.x
		actor.velocity.y = actor.velocity.y
		await get_tree().create_timer(duration).timeout
		actor.velocity.x = 0
	isDashing = false
	
#	globalFunc.FlashSprite(actor.playerSprite,Vector3(1, 0, 0),0)
	
	# State Transitions
	HandleStateTransition(actor)

func OnPlayerStaminaChanged(staminaValue, _staminaState):
	currentStamina = staminaValue

func CheckStamina(delta):
	if currentStamina > staminaCost * delta:
		canDash = true
	else:
		canDash = false

func HandleStateTransition(actor):
	if actor.is_on_floor():
		actor.stateMachine.set_state(get_parent().IDLE)
	else: actor.stateMachine.set_state(get_parent().FALLING)	
