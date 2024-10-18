extends Node

var rayCast
var castGrid = 0.1
var selectedMainObj = {"body":null, "collider":null}
var selectedCompObj = {"body":null, "collider":null}

var mainObjectNode : Node3D
var pickedComponentNode : Node3D
var dismantledComponentNode : Node3D

# Game class_state
enum mainObjStates {OBJ_PICKUP, OBJ_PUT}
var currentMainObjState := mainObjStates.OBJ_PUT

enum compObjStates {COMP_PICKUP, COMP_PUT}
var currentCompObjState := compObjStates.COMP_PUT

func _ready():
	game.worldNode = get_parent()
	game.mainCam = get_viewport().get_camera_3d()
	mainObjectNode = get_parent().get_node("MainObject")
	pickedComponentNode = get_parent().get_node("PickedComponent")
	dismantledComponentNode = get_parent().get_node("DismantledComponent")
	
	InitDismantlePlay()

func _process(delta):
	rayCast = game.RayCastFromMouse()
	
	match currentMainObjState:
		mainObjStates.OBJ_PUT:
			if rayCast and rayCast.collider.is_in_group("dismantleMainBody"):
				PickMainObject(rayCast)		
		mainObjStates.OBJ_PICKUP:
			if rayCast and rayCast.collider.is_in_group("dismantleSurface") :
				PutMainObject()		
			RotateMainObject(mainObjectNode.get_child(0), deg_to_rad(45))
	match currentCompObjState:
		compObjStates.COMP_PUT:
			if rayCast and rayCast.collider.is_in_group("dismantleComponent") :
				PickCompObject(rayCast)		
		compObjStates.COMP_PICKUP:
			if rayCast:
				MoveCompObjectOnSurface(selectedCompObj, rayCast)		
				if rayCast.collider.is_in_group("dismantleSurface") and selectedCompObj.body:
					PutCompObject(rayCast)	

func PutMainObject():
	if Input.is_action_just_pressed("dismantle_interact") and currentCompObjState == compObjStates.COMP_PUT:
		currentMainObjState = mainObjStates.OBJ_PUT
		HandleRotation(mainObjectNode.get_child(0), Vector3(rad_to_deg(0),rad_to_deg(0),rad_to_deg(0)), "rotation")	
		var newPos = Vector3(0, 0, 0) # Move object to the surface
		HandleTranslateMovement(mainObjectNode.get_child(0), newPos)
		selectedMainObj.body = null
		selectedMainObj.collider = null

func PutCompObject(cast):
	if Input.is_action_just_pressed("dismantle_interact"):
		currentCompObjState = compObjStates.COMP_PUT
		HandleRotation(selectedCompObj.body, Vector3(rad_to_deg(0),rad_to_deg(0),rad_to_deg(0)), "rotation")	
		var newPos = cast.position
		#newPos = Vector3(cast.position.x,-0.25,cast.position.z)
		HandleTranslateMovement(selectedCompObj.body, newPos)
		selectedCompObj.body = null
		selectedCompObj.collider = null
	
func PickMainObject(context):
	if Input.is_action_just_pressed("dismantle_interact") :
		currentMainObjState = mainObjStates.OBJ_PICKUP
		selectedMainObj.body = context.collider
		selectedMainObj.collider =  game.GetChildNodeWithType(context.collider,"CollisionShape3D")[0]
		var newPos = Vector3(0, 0.5, 0) # Move object to center scene
		HandleRotation(mainObjectNode.get_child(0), Vector3(deg_to_rad(45),deg_to_rad(0),deg_to_rad(45)), "rotation")	
		HandleTranslateMovement(mainObjectNode.get_child(0), newPos)
		#GameManager.sfxPick.play()

func PickCompObject(context):
	if Input.is_action_just_pressed("dismantle_interact") and currentMainObjState == mainObjStates.OBJ_PICKUP:
		if game.GetChildNodeWithType(context.collider,"StaticBody3D") == []:
			currentCompObjState = compObjStates.COMP_PICKUP
			HandleRotation(selectedCompObj.body, Vector3(rad_to_deg(0),rad_to_deg(0),rad_to_deg(0)), "rotation")	
			#DuplicateNodeToPickedComponent(context.collider, pickedComponentNode)
			var dupe = context.collider.duplicate()
			pickedComponentNode.add_child(dupe)
			selectedCompObj.body = dupe
			selectedCompObj.collider = game.GetChildNodeWithType(dupe,"CollisionShape3D")[0]
			var childMesh = game.GetChildNodeWithType(dupe,"MeshInstance3D")[0]
			childMesh.position = Vector3.ZERO
			context.collider.queue_free()	
			var clickFX = get_parent().get_node("FXClick")		
			clickFX.emitting = true
			clickFX.position = game.mainCam.unproject_position(rayCast.position)
		else:
			selectedCompObj.body = null
			selectedCompObj.collider = null
			fx.screenShake(0.1, 0.025)
		#GameManager.sfxPick.play()

func RotateMainObject(context, rotation):
	if Input.is_action_just_pressed("dismantle_rotate_up"):
		rotation = context.rotation.x - rotation
		HandleRotation(context, rotation, "rotation:x")	
	if Input.is_action_just_pressed("dismantle_rotate_down"):
		rotation = context.rotation.x + rotation		
		HandleRotation(context, rotation, "rotation:x")
	if Input.is_action_just_pressed("dismantle_rotate_right"):
		rotation = context.rotation.z - rotation
		HandleRotation(context, rotation, "rotation:z")	
	if Input.is_action_just_pressed("dismantle_rotate_left"):
		rotation = context.rotation.z + rotation		
		HandleRotation(context, rotation, "rotation:z")		

func HandleRotation(context, rotation, propertyString):
	if context:
		var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(
			context,
			propertyString,
			rotation,
			0.15)	

func HandleTranslateMovement(context, newPos):
	if context:
		var tween = create_tween().set_trans(Tween.TRANS_BACK)
		tween.tween_property(
			context,
			"position",
			newPos,
			0.2)

func MoveCompObjectOnSurface(context, source):
	if context.body and context.body.is_in_group("dismantleComponent"):
			context.collider.disabled = true
			context.body.position = source.position.snapped(Vector3(castGrid, castGrid, castGrid))


#region Init 
func InitDismantlePlay():
	if mainObjectNode and mainObjectNode.get_child_count() > 0:
		print("initialize main Object")
		if mainObjectNode.get_child(0).get_class() == "StaticBody3D":
			print("initialize Static Body")
			var obj = mainObjectNode.get_child(0).duplicate()
			mainObjectNode.get_child(0).free()
			obj.scene_file_path = ""
			obj.owner = get_tree().get_edited_scene_root()
			if mainObjectNode.get_child_count() == 0:
				mainObjectNode.add_child(obj)
				obj.name = "MainBody"
				obj.add_to_group("dismantleMainBody", true)
				
				RecursiveMeshParentToStatic(mainObjectNode.get_child(0).get_child(0))					
				
		RecursiveConfig(mainObjectNode.get_child(0))
		AddCollisionSiblingToMesh(mainObjectNode.get_child(0).get_child(0))	

func RecursiveMeshParentToStatic(context):
	for meshes in context.get_children():
		if meshes.get_class() == "MeshInstance3D":
			var oldMeshPosition = meshes.position
			var newStatic = StaticBody3D.new()
			newStatic.name = meshes.name + "_Static"
			var parentNode = meshes.get_parent()
			parentNode.get_parent().add_child(newStatic)
			parentNode.remove_child(meshes)
			newStatic.add_child(meshes)
			meshes.position = Vector3.ZERO
			newStatic.position = oldMeshPosition
			RecursiveMeshParentToStatic(meshes)

func RecursiveConfig(context):
	if game.GetChildNodeWithType(context, "StaticBody3D").size() == 0:
		return
	for staticChild in game.GetChildNodeWithType(context, "StaticBody3D"):
		staticChild.add_to_group("dismantleComponent", true)
		AddCollisionSiblingToMesh(staticChild.get_child(0))
		staticChild.get_child(0).name = staticChild.get_child(0).name + "_Mesh"
		RecursiveConfig(staticChild)

func AddCollisionSiblingToMesh(mesh):
	if mesh.get_class() == "MeshInstance3D":
		mesh.create_convex_collision()
		var collisionStatic = mesh.get_child(0)
		var collisionShape = collisionStatic.get_child(0)
		collisionShape.name = mesh.name + "_Col"
		collisionStatic.remove_child(collisionShape)
		mesh.remove_child(collisionStatic)
		mesh.get_parent().add_child(collisionShape)
#endregion
