extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("Stat Health")
@export var maxHealth = 100.0

@export_group("Stat Stamina")
@export var maxStamina = 100.0
var canStaminaRefill = true

@export_group("Jogging")
@export var joggingSpeed = 250.0
@export var sprintingSpeed = 200.0
@export var sprintingDurationSec = 2
@export var acceleration = 35
@export var friction = 50
var stamCostSprinting = maxStamina / sprintingDurationSec

@export_group("Jumping")
@export var jumpHeight:float = 100
@export var jumpTimeToPeak:float = 0.6
@export var jumpTimeToFall:float = 0.55
@export var maxJumpCount = 2
var jumpCount = maxJumpCount
@export var secondJumpRate = 1.2
@export var jumpCutRate = 0.3
@export var airMovementRate = 0.75
var airHorizontalSpeed = joggingSpeed * airMovementRate

var jumpVelocity = ((2.0 * jumpHeight) / jumpTimeToPeak) * -1.0
var jumpGravity = ((-2.0 * jumpHeight) / (jumpTimeToPeak * jumpTimeToPeak)) * -1.0
var fallGravity = ((-2.0 * jumpHeight) / (jumpTimeToFall * jumpTimeToFall)) * -1.0

@export_group("Dashing")
@export var airDashSpeed = 95000
@export var groundDashSpeed = 95000
@export var dashDuration = 0.125
@export var dashConsecutive = 2.25
var stamCostDash = maxStamina / dashConsecutive

@export_group("Gliding")
@export var glidingGravity = 15
@export var glidingMoveSpeed = 75
@export var glidingDurationSec = 3
var stamCostGliding = maxStamina / glidingDurationSec

@export_group("Pounding")
@export var poundSpeed = 200000
@export var poundDuration = 0.1
@export var poundBounceRate = 1.5
@export var poundConsecutive = 2.5
var stamCostPound = maxStamina / poundConsecutive

@export_group("Warping")
@export var warpingDurationSec = 10
var stamCostWarping = maxStamina / warpingDurationSec


#========================================

# ABILITY TOGGLE
@export var maskStagOwned = false
@export var maskToadOwned = false
@export var maskRavenOwned = false
@export var maskHumeOwned = false

#========================================

@export var stamina: PlayerStamina
@export var controller: PlayerInput

@onready var playerSprite = $Sprite2D
@onready var playerAnim = $AnimationPlayer
@onready var coyoteTimer = $playerState/coyoteTimer

var playerFacingDirection = 1 #Look Right by default

enum playerStates {
	IDLE, JOGGING, JUMPING, DOUBLE_JUMPING, FALLING, GLIDING, GROUND_DASHING, AIR_DASHING, POUNDING
}

enum abilityWarpStates {
	WARP_READY, WARP_SCANNING, WARPING
}

enum gravityType {
	WORLD, JUMPFALL
}

var currentState = playerStates.IDLE
var previousState = playerStates.IDLE
var currentWarpingState = abilityWarpStates.WARP_READY

# StateMachine
@export_group("Player State")
@export var stateMachine: StateMachine
@export var abilityStateMachine: StateMachine

func _physics_process(_delta):
	controller.InputHandler()
	FlipPlayer()
	move_and_slide()
	events.emit_signal("player_global_position", self.global_position)
	
	stamina.HandleStaminaStateTransitions()
	events.emit_signal("player_stamina_changed", stamina.currentStamina, stamina.staminaState.keys()[stamina.currentStaminaState])
	
func FlipPlayer():
	if controller.inputMoveRightPress:
		SetPlayerFacingDirection(self, 1)
	elif controller.inputMoveLeftPress:
		SetPlayerFacingDirection(self, -1)

func _input(event):
	if event.is_action_pressed("input_dash"):
		controller.currentInput = controller.inputStates.INPUT_DASHING
	elif event.is_action_pressed("input_glide"):
		controller.currentInput = controller.inputStates.INPUT_GLIDING
	elif event.is_action_pressed("input_sprint"):
		controller.currentInput = controller.inputStates.INPUT_SPRINTING

func SetPlayerFacingDirection(context, value):
	context.transform.x.x = value
	context.playerFacingDirection = value

func ChangeAndEmitCurrentPlayerState(states):
	currentState = states
	events.emit_signal("player_state_changed", playerStates.keys()[currentState], playerStates.keys()[previousState])

func ChangeAndEmitPreviousPlayerState(states):
	previousState = states
	events.emit_signal("player_state_changed", playerStates.keys()[currentState], playerStates.keys()[previousState])

func ApplyGravity(type):
	var force = gravity
	match type:
		gravityType.WORLD:
			force = gravity
		gravityType.JUMPFALL:
			force = jumpGravity
	velocity.y += force * get_physics_process_delta_time()

func ApplyAirHMove():
	velocity.x = controller.movementVector * airHorizontalSpeed

func CheckEnoughStamina(currentStamina, staminaCost):
	if currentStamina > staminaCost * get_physics_process_delta_time():
		return true
	else:
		return false

func PlayAnim(animName : String):
	if playerAnim:
		playerAnim.play(animName)
