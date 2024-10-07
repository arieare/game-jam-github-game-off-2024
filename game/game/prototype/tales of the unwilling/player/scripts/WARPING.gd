extends State

var isWarping
var arrowToWarp
var objectToWarp

func _ready():
	objectToWarp = null
	events.connect("weapon_arrow_spawned", OnArrowSpawned)
	events.connect("body_warp_selected", SetObjectToWarp)

func enter(actor):
	globalFunc.TeleportSprite(actor.playerSprite,1,0)
	actor.currentWarpingState = actor.abilityWarpStates.WARPING
	events.emit_signal("player_ability_warping_state_changed", actor.abilityWarpStates.keys()[actor.currentWarpingState])
	pass

func update(delta, actor):
#	await get_tree().create_timer(0.05).timeout	
	HandleStateTransition(actor)
	pass

func exit(actor):
	await get_tree().create_timer(0.05).timeout		
	var pivotPos = actor.global_position 
	if objectToWarp != null:
		actor.global_position = objectToWarp.global_position
		await get_tree().create_timer(0.05).timeout
		objectToWarp.global_position = pivotPos
#		actor.global_position.y = actor.global_position.y - 30
		globalFunc.FreezeFrame(0.2)
	elif is_instance_valid(arrowToWarp):
		actor.global_position = arrowToWarp.global_position
		actor.global_position.y = actor.global_position.y - 20
		globalFunc.FreezeFrame(0.2)	
	
#	await get_tree().create_timer(0.05).timeout		
	if is_instance_valid(arrowToWarp):
		arrowToWarp.queue_free()
	globalFunc.TeleportSprite(actor.playerSprite,0,1)
	globalFunc.DecayingSlowMo(0.001,4)

func HandleStateTransition(actor):
	actor.abilityStateMachine.set_state(get_parent().WARP_READY) 
	

func OnArrowSpawned(arrowSpawn):
	if is_instance_valid(arrowSpawn):
		arrowToWarp = arrowSpawn
	else:
		arrowToWarp = null	

func SetObjectToWarp(object):
	objectToWarp = object
