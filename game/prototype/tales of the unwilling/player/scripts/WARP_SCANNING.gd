extends State

var canWarpScan = true
var currentStamina
var staminaCost
var arrowBulletSpawn = null
var slowMoRate = 0.05
var warpableObjectsArray: Array = []
var warpableObjectsSelectorIndex: int = 0
var warpScanRadius = 300
var objectToWarp

func _ready():
	events.connect("player_stamina_changed", OnPlayerStaminaChanged)
	events.connect("weapon_arrow_spawned", OnArrowSpawned)
	events.connect("body_warp_scanned", CatalogueScannedBodies)
	events.connect("body_warp_removed", RemoveScannedBodies)

func enter(actor):
	objectToWarp = null
	staminaCost = actor.stamCostWarping
	actor.currentWarpingState = actor.abilityWarpStates.WARP_SCANNING
	events.emit_signal("player_ability_warping_state_changed", actor.abilityWarpStates.keys()[actor.currentWarpingState])
	pass

func update(delta, actor):
	# Check if there is bullet to scan
	if not arrowBulletSpawn == null:
		if actor.controller.inputWarpPress:
			# Check if enough Stamina
			CheckStamina(delta)
			
			#State Logic
			if canWarpScan:
				actor.velocity = Vector2.ZERO

				TurnOnWarpScanner(arrowBulletSpawn)
				SelectObjectToWarp(actor)
				Engine.time_scale = slowMoRate # experimental
				actor.canStaminaRefill = false
				actor.stamina.Drain(staminaCost * delta / slowMoRate)
#				# Append Arrow as one of the warp option
#				var arrowDist: float = get_parent().get_parent().global_position.distance_to(arrowBulletSpawn.position)
#				warpableObjectsArray.append({"warpObject": arrowBulletSpawn, "warpDistance": arrowDist})
	else:
		actor.abilityStateMachine.set_state(get_parent().WARP_READY) 
	
	#State Transitions
	HandleStateTransition(actor)
	pass

func exit(actor):
	ResetWarpScanner(arrowBulletSpawn)
	actor.canStaminaRefill = true
	Engine.time_scale = 1 #rest time scale
	events.emit_signal("body_warp_selected", objectToWarp)
#	actor.ChangeAndEmitPreviousPlayerState(actor,actor.currentState)
	pass

func HandleStateTransition(actor):
	if not actor.controller.inputWarpPress or not canWarpScan:	
		actor.abilityStateMachine.set_state(get_parent().WARPING) 

func CheckStamina(delta):
	if currentStamina > staminaCost * delta:
		canWarpScan = true
	else:
		canWarpScan = false

func OnPlayerStaminaChanged(staminaValue, _staminaState):
	currentStamina = staminaValue	

func OnArrowSpawned(arrowBullet):
	if is_instance_valid(arrowBullet):
		arrowBulletSpawn = arrowBullet
	else:
		arrowBulletSpawn = null

func TurnOnWarpScanner(arrowBulletSpawn):
	if is_instance_valid(arrowBulletSpawn):
		if arrowBulletSpawn.warpScanner && arrowBulletSpawn.warpScanCollider is CollisionShape2D:
			arrowBulletSpawn.warpScanCollider.shape.radius = warpScanRadius
			arrowBulletSpawn.warpScanner.monitoring = true
			arrowBulletSpawn.warpScanner.visible = true

func ResetWarpScanner(arrowBulletSpawn):
	if is_instance_valid(arrowBulletSpawn):
		if arrowBulletSpawn.warpScanner && arrowBulletSpawn.warpScanCollider is CollisionShape2D:
			arrowBulletSpawn.warpScanCollider.shape.radius = 0.0
			arrowBulletSpawn.warpScanner.monitoring = false
			arrowBulletSpawn.warpScanner.visible = false

func CatalogueScannedBodies(bodies):
	var distance: float = get_parent().get_parent().global_position.distance_to(bodies.position)
	warpableObjectsArray.append({"warpObject": bodies, "warpDistance": distance})
	warpableObjectsArray.sort_custom(CustomSort)

func RemoveScannedBodies(bodies):
	var distance: float = get_parent().get_parent().global_position.distance_to(bodies.position)
	var arrayIndex = warpableObjectsArray.find({"warpObject": bodies, "warpDistance": distance},0)
	UnaimSelected(warpableObjectsArray[arrayIndex]["warpObject"])
	warpableObjectsArray.erase({"warpObject": bodies, "warpDistance": distance})

func SelectObjectToWarp(actor):
	if Input.is_action_just_pressed("input_shoot") && warpableObjectsArray.size() > 0:
		warpableObjectsSelectorIndex = IncrementWarpSelector(warpableObjectsSelectorIndex, warpableObjectsArray.size() - 1)
		AimSelected(warpableObjectsArray[warpableObjectsSelectorIndex]["warpObject"])
		if warpableObjectsArray.size() > 1:
			UnaimSelected(warpableObjectsArray[warpableObjectsSelectorIndex - 1]["warpObject"])
		objectToWarp = warpableObjectsArray[warpableObjectsSelectorIndex]["warpObject"]

func IncrementWarpSelector(selector, maxIndex) -> int:
	return (selector + 1) % (maxIndex + 1)

func AimSelected(object):
	if is_instance_valid(object) and object.has_method("AimedAt"):
		object.AimedAt()

func UnaimSelected(object):
	if is_instance_valid(object) and object.has_method("AimReset"):
		object.AimReset()


func CustomSort(a, b) -> int:
	if a["warpDistance"] < b["warpDistance"]:
		return true
	return false
