extends State

var arrow = preload("res://weapon/arrow_bullet.tscn")
var spawnedArrow
var arrowShootDirection
var weaponFacing
var canShoot = true

func _ready():
	events.connect("player_ability_warping_state_changed", OnPlayerWarpingStateChanged)

func enter(actor):
	if canShoot:
		weaponFacing = actor.scale.x
#		if actor.bowSprite:
#			actor.bowSprite.set_frame(2)
		SpawnArrow(actor)
	actor.ChangeAndEmitCurrentWeaponState(actor.weaponBowStates.SHOOT)
	actor.player.playerSprite.play("throwing")

func update(_delta, actor):
	#State Transitions
	await get_tree().create_timer(0.05).timeout
	actor.stateMachine.set_state(get_parent().READY) 

func exit(actor):
	await get_tree().create_timer(0.15).timeout
	actor.player.playerSprite.play("idle")
	pass

func SpawnArrow(actor):
	arrowShootDirection = RotationtoDirection(actor.rotation)
	spawnedArrow = arrow.instantiate()
	get_tree().root.get_node("world").add_child(spawnedArrow)
	spawnedArrow.global_position = actor.global_position
	spawnedArrow.rotation = actor.rotation
	SetArrowSpeed(spawnedArrow, 800)
	events.emit_signal("weapon_arrow_spawned", spawnedArrow) 
	return spawnedArrow

func SetArrowSpeed(arrowBullet, speed):
	if is_instance_valid(arrowBullet):
		arrowBullet.velocity = arrowShootDirection * speed * weaponFacing
	
func RotationtoDirection(deg: float) -> Vector2:
	var angle = deg
	var x = cos(angle)
	var y = sin(angle)
	return Vector2(x, y)

func OnPlayerWarpingStateChanged(warpingState):
	if is_instance_valid(spawnedArrow):
		if warpingState == "WARP_SCANNING":
			SetArrowSpeed(spawnedArrow, 900)
			canShoot = false
			spawnedArrow.arrowHead.monitoring = false
		else:
			SetArrowSpeed(spawnedArrow, 900)
			canShoot = true
			spawnedArrow.arrowHead.monitoring = true
