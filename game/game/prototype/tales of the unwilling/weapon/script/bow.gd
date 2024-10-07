extends Node2D

@onready var player = get_tree().get_root().get_node("world").get_node("WorldEnvironment").get_node("player")
@onready var bowSprite = $bowSprite

var isShooting = false
var isAiming = false
var shadowAim
@export var maxAimRadius = 100


# Input
var inputShootPressStart
var inputShootPress
var inputShootPressRelease

enum weaponBowStates {
	READY, DRAW, AIM, SHOOT
}

var currentBowState = weaponBowStates.READY

# StateMachine
@export_group("Bow State")
@export var stateMachine: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	shadowAim = player.global_position

func _process(delta):	
	InputHandler()
	UpdateBowPosition();

func _input(event):
	if event is InputEventMouseMotion:
		isAiming = true
		shadowAim += event.relative
	
	elif event is InputEventJoypadMotion:
		isAiming = true
		var analogMovement = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		if analogMovement.length() > 0.4:
			shadowAim = player.global_position + analogMovement * maxAimRadius * -1
	else: 
		isAiming = false

func InputHandler():
	inputShootPressStart = Input.is_action_just_pressed("input_shoot")
	inputShootPressRelease = Input.is_action_just_released("input_shoot")
	inputShootPress = Input.is_action_pressed("input_shoot")

func ResetBowRotation(delta):
	self.rotation = lerpf(0, self.rotation, pow(2, -40 * delta))
	
func UpdateBowPosition():
	position = player.global_position
	position.y = player.global_position.y + 24
	skew = 0
	scale.x = player.playerFacingDirection

func ChangeAndEmitCurrentWeaponState(states):
	currentBowState = states
	events.emit_signal("weapon_bow_state_changed", weaponBowStates.keys()[currentBowState])
