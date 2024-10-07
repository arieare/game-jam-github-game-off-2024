extends State

var canDraw = true

func _ready():
	events.connect("player_ability_warping_state_changed", OnPlayerWarpingStateChanged)

func enter(actor):
	if canDraw:
#		if actor.bowSprite:
#			actor.bowSprite.set_frame(1)
		actor.ChangeAndEmitCurrentWeaponState(actor.weaponBowStates.DRAW)

func update(delta, actor):
	#State Transitions
	if actor.inputShootPressStart:
		pass
#	if Input.is_action_just_released("mdv_ui_cancel"):
#		actor.stateMachine.set_state(get_parent().READY) 
	if actor.inputShootPress and actor.isAiming:
		actor.stateMachine.set_state(get_parent().AIM) 
	if actor.inputShootPressRelease:
		actor.stateMachine.set_state(get_parent().SHOOT) 	

func exit(_actor):
	pass


func OnPlayerWarpingStateChanged(warpingState):
	if warpingState == "WARP_SCANNING":
		canDraw = false
	else:
		canDraw = true
