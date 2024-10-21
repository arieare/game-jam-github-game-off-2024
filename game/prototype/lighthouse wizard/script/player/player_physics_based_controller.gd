extends RigidBody3D

#Walk values.
@export var maxSpeed: float = 6
@export var acceleration: float = 40

#Jump values
@export var jumpSpeed: float = 5
@export var jumpHoldForce: float = 4.9
@export var jumpMinHoldTime: float = 0.25
@export var maxJumpTime: float = 0.75
@export var jumpDownSpeed: float = 5
@export var airControl: float = 0.5

#Maximum angle (in degrees) in which an slope still count as ground.
@export var maxFloorAngle: float = 46

#Levitation values.
@export var levitationDistance: float = 1.25
@export var levitationStiffness: float = 1000
@export var levitationDamp: float = 50

#Snapping values.
@export var snapDistance: float = 1
@export var snapDistanceMultiplier: float = 0.1

var isOnFloor : bool = false
var floorNormal : Vector3 = Vector3.UP
var floorSlope : float = 0.0

var isJumping : bool = false
var timeSinceJump : float = 100


#Get the RayCast node.
@export var levRay : RayCast3D


var time = 0.0
var pos

func _ready():
	
	#Set the raycast to the levitation distance.
	levRay.target_position.y = -levitationDistance
	
	return


func _physics_process(delta):
	
	#Force the ray to provide updated info.
	levRay.force_raycast_update()
	
	#Check for floor.
	floor_check()
	
	#Move The character.
	movement(delta)
	self.rotation.z = lerp(self.rotation.z, 0.0, 0.75)
	self.rotation.x = lerp(self.rotation.x, 0.0, 0.75)
	#Player levitation and snapping.
	levitation(delta)
	
	#Handle Jump.
	#jump(delta)
	
#func _process(delta):

	#self.rotation.z = 0.0
	#self.rotation.x = 0.0
#Returns the player's wish direction.
func wish_direction(local : bool = false)->Vector3:
	
	#Store the input vector.
	var playerInput: Vector2 = Input.get_vector(
		"player_move_left",
		"player_move_right",
		"player_move_backward",
		"player_move_forward"
		)
		
	#Create a vector3 with the input vector.
	var wishDirection : Vector3 = Vector3(playerInput.x, 0, -playerInput.y)
	
	#If is called with the local parameter set to false, normalize and return.
	if !local :
		
		if wishDirection.length() > 1:
			
			wishDirection = wishDirection.normalized()
			
		return wishDirection
	
	#If local is set to true,  Rotate the wishDirection  by the yaw rotation.
	var yawRotation : float = $CameraGimbal/Yaw.global_rotation.y
	var localWishDirection : Vector3 = wishDirection.rotated(Vector3.UP, yawRotation)
	
	#Normalize and return.
	if localWishDirection.length() > 1:
		
		localWishDirection = localWishDirection.normalized()
		
	return localWishDirection

#Returns a dictionary with information about the raycast.
func ground_check()->Dictionary:

	var isColliding : bool = false
	var collisionPosition : Vector3  = Vector3.ZERO
	var collisionDistance : float = 0.0
	var collisionNormal :Vector3  = Vector3.ZERO
	var collisionSlope : float = 0.0
	var collisionBody = null
	var collisionBodyVel = Vector3.ZERO

	if levRay.is_colliding():

		isColliding = true
		collisionPosition = levRay.get_collision_point()
		collisionDistance = global_position.distance_to(collisionPosition)
		collisionNormal = levRay.get_collision_normal()
		collisionSlope =  rad_to_deg(acos(collisionNormal.dot(Vector3.UP)))
		collisionBody = levRay.get_collider()
		
		if collisionBody is RigidBody3D:
			
			collisionBodyVel = get_velocity_at_position(collisionBody, collisionPosition)
			
	var results : Dictionary = {

		"isColliding": isColliding,
		"collisionPosition": collisionPosition,
		"collisionDistance": collisionDistance,
		"collisionNormal": collisionNormal,
		"collisionSlope": collisionSlope,
		"collisionBody" : collisionBody,
		"collisionBodyVel" : collisionBodyVel
		}
		
	return results

#Floor check code.
func floor_check()->void:
	
	var maxFloorDot : float = cos(deg_to_rad(maxFloorAngle))
	
	isOnFloor = false
	floorNormal = Vector3.ZERO
	floorSlope = 0.0
	
	if !ground_check().isColliding:
		
		return
		
	
	if !ground_check().collisionNormal.dot(Vector3.UP) > maxFloorDot:
		
		return
		
	
	isOnFloor = true
	floorNormal = ground_check().collisionNormal
	floorSlope = rad_to_deg(acos(floorNormal.dot(Vector3.UP)))
	
	if ground_check().collisionBody is RigidBody3D:
		
		var body : CollisionObject3D = ground_check().collisionBody
		var contactPosition : Vector3 = ground_check().collisionPosition
		
	
	return

#Levitation and snap code.
func levitation(delta)->void:
	
	#If the ray is not colliding anymore remove the snap distance.
	if !ground_check().isColliding:
		
		levRay.target_position.y = -levitationDistance
		
		return
	
	#Final snap distance
	
	var relYVel : float = linear_velocity.y - ground_check().collisionBodyVel.y
	var snapDistMultiplier : float = linear_velocity.y * snapDistanceMultiplier
	
	snapDistMultiplier = clamp(snapDistMultiplier, 0, 1)
	
	var finalSnapDistance : float = snapDistance - snapDistance * snapDistMultiplier
	
	levRay.target_position.y = -levitationDistance - finalSnapDistance
	
	#Levitation spring
	var offset : float = ground_check().collisionDistance - levitationDistance
	var stiffness : float = -offset * levitationStiffness
	var damp : float = relYVel * levitationDamp
	var springForce : float = stiffness - damp

	#If we are under the levitation distance, push up.
	if offset < 0:
		
		apply_central_force(Vector3.UP * springForce * mass)
		
		#Apply force to the object we are standing on.
		if ground_check().collisionBody is RigidBody3D:
			
			var body : RigidBody3D = ground_check().collisionBody
			var contactPosition : Vector3 = ground_check().collisionPosition
			var staticForce : float =  mass * 5
			var dynamicForce : float  = clamp(-relYVel, 0 , INF) * mass * 5
			var finalForce : Vector3 = Vector3.DOWN * (staticForce + dynamicForce)
			
			body.apply_force(finalForce, contactPosition -  body.position)
		
		return 
		
		
	#Check if there is a free path to snap.
	var characterHalfSize : float = $CollisionShape3D.shape.height / 2
	var castDistance : float = (ground_check().collisionDistance - characterHalfSize) * 0.9
	var canSnap : bool = not test_move(self.global_transform, Vector3.DOWN * castDistance)
	
	#If we are above the levitation distance but the ray hits floor, push down.
	if isOnFloor and canSnap:
		
		apply_central_force(Vector3.UP * springForce * mass)

#Movement code.
func movement(delta):
	
	#Acceleration multiplier
	var multiplier : float = 2
	
	if !ground_check().isColliding:
		multiplier = airControl
		
	var horizontalVel = linear_velocity * Vector3(1, 0, 1)
	var horizontalGroundVel = ground_check().collisionBodyVel * Vector3(1, 0, 1)
	var wishVelocity:Vector3 = (wish_direction() * maxSpeed) + horizontalGroundVel
	var goalAcceleration = wishVelocity - horizontalVel
	var ForceToGoalAcceleration = goalAcceleration / delta
	
	#Clamp ForceToGoalAcceleration to our maximum allowed acceleration.
	if ForceToGoalAcceleration.length() > acceleration * multiplier: 
		ForceToGoalAcceleration = (ForceToGoalAcceleration.normalized() * acceleration * multiplier)
	
	#print(self.linear_velocity.length())
	time = time + delta
	if self.linear_velocity.length() > 1:
		
		pos = sin(time*5*PI)
		pos = clampf(pos,-0.12,0.12)
		self.apply_central_impulse(Vector3(0,pos,0))
	else:
		pos = sin(time*1.3*PI)
		pos = clampf(pos,-0.15,0.15)
		self.apply_central_impulse(Vector3(0,pos,0))		
		#$body.position.y = $body.position.y - pos
	

	
	apply_torque(-self.angular_velocity)
	
	#apply_force(ForceToGoalAcceleration * mass, self.global_position + Vector3(0, self.scale.y * 0.25, 0.0))
	#look_at(global_position + self.linear_velocity, Vector3.UP)
	apply_central_force(ForceToGoalAcceleration * mass)
		

#Jump Code.
#func jump(delta)->void:
	#
	##If we are on floor and want to jump, jump.
	#if ground_check().isColliding and Input.is_action_just_pressed("jump"):
		#
		#isJumping = true
		#timeSinceJump = 0
		#levRay.target_position.y = -levitationDistance
		#
		##Detach the character from the floor.
		#if ground_check().collisionDistance < levitationDistance:
			#
			#global_position.y += levitationDistance + 0.01 - ground_check().collisionDistance
			#
		#
		##Force a ray update.
		#levRay.force_raycast_update()
		#
		##Start the jump.
		#set_axis_velocity(jumpSpeed * Vector3.UP )
		#
		#return
	#
	##If the character is not jumping, we stop here.
	#if !isJumping:
		#
		#return
		#
	#
	#timeSinceJump += delta
	#
	##hold the jump for the minimum time.
	#if timeSinceJump < jumpMinHoldTime:
		#
		#apply_central_force(Vector3.UP * jumpHoldForce * mass)
		#
		#return
	#
	##If we released the jump key, reached the apex of the jump or it's maximum time, apply jump down speed
	#if !Input.is_action_pressed("jump") or linear_velocity.y <= 0 or timeSinceJump > maxJumpTime:
		#
		#isJumping = false
		#set_axis_velocity(Vector3.DOWN * jumpDownSpeed)
		#
		#return
	#
	##If the jump didn't finished, keep the jump hold force.
	#apply_central_force(Vector3.UP * jumpHoldForce * mass)

#Returns the global velocity at a given position in global space
func get_velocity_at_position(body : RigidBody3D, position : Vector3)->Vector3:
	
	var bodyVel : Vector3 = body.linear_velocity
	var bodyAngVel : Vector3= body.angular_velocity
	var centerOfMass : Vector3 = body.to_global(body.center_of_mass)
	var velocityAtPosition : Vector3 = bodyVel + bodyAngVel.cross(position - centerOfMass)
	
	return velocityAtPosition
