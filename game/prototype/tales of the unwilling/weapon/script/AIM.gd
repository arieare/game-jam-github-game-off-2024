extends State

var aimCursor = preload("res://weapon/bow_aim_cursor.tscn")
var spawnedAim

func enter(actor):
	globalFunc.DecayingSlowMo(0.001,2.5) # Slowmo for aiming
	SpawnAim(actor)
	actor.ChangeAndEmitCurrentWeaponState(actor.weaponBowStates.AIM)
	actor.player.playerSprite.play("winding")

func update(_delta, actor):
	ClampAimCursorRadius(actor, actor.maxAimRadius)
	FlipPlayerToLookAt(actor)
	AimBow(actor)
	HandleStateTransition(actor)

func exit(_actor):
	globalFunc.ResetTime()
	DestroyAim(spawnedAim)

func FlipPlayerToLookAt(actor):
	if (actor.shadowAim.x - actor.player.global_position.x) < 0:
		actor.player.SetPlayerFacingDirection(actor.player, -1)
		actor.transform.x.x = -1
	else: 
		actor.player.SetPlayerFacingDirection(actor.player, 1)
		actor.transform.x.x = 1

func ClampAimCursorRadius(actor, aimRadius):
	var offset = actor.shadowAim - actor.player.global_position
	var length = offset.length()
	if length > aimRadius:
		var clampedOffset = offset.normalized() * aimRadius
		actor.shadowAim = actor.player.global_position + clampedOffset
	spawnedAim.global_position = actor.shadowAim

func AimBow(actor):
	var direction = (spawnedAim.global_position - actor.global_position).normalized()
	var angle = direction.angle()  # Calculate the angle between direction and (1, 0)
	actor.rotation = angle
	actor.skew = 0
	actor.scale = Vector2(1,1)

func HandleStateTransition(actor):
	if actor.inputShootPressRelease:
		actor.stateMachine.set_state(get_parent().SHOOT) 

func SpawnAim(actor):
	spawnedAim = aimCursor.instantiate()
	spawnedAim.global_position = actor.player.global_position
	get_tree().root.add_child(spawnedAim)
	actor.shadowAim = actor.player.global_position
	return spawnedAim

func DestroyAim(aim):
	aim.queue_free()
