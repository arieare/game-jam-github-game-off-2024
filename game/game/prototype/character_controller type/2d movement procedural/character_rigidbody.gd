extends RigidBody2D


## Movement
var move_direction: Vector2
@onready var movement_node = $movement
@onready var input_node = $input


#Levitation values.
@export var levitationDistance: float = 45 # 35
@export var levitationStiffness: float = 100
@export var levitationDamp: float = 5

#Snapping values.
@export var snapDistance: float = 1.0
@export var snapDistanceMultiplier: float = 0.1

var isOnFloor : bool = false
var floorNormal : Vector2 = Vector2.UP
var floorSlope : float = 0.0

#Get the RayCast node.
@export var levitation_raycast : RayCast2D

var cast_contact_point : Vector2 = Vector2.ZERO
#Maximum angle (in degrees) in which an slope still count as ground.
@export var max_floor_angle: float = 46

# Ref https://medium.com/@merxon22/recreating-rain-worlds-2d-procedural-animation-part-2-f5faef82aa50
## REGION step updater
@onready var target_leg_left = $"../target_node/target_l"
@onready var desired_step_l = $"../target_node/step_l"
@export var foot_left_start_position:Vector2
@export var foot_left_mid_position:Vector2
@export var foot_left_end_position:Vector2
var left_interpolate: float

@onready var target_leg_right = $"../target_node/target_r"
@onready var desired_step_r = $"../target_node/step_r"
@export var foot_right_start_position:Vector2
@export var foot_right_end_position:Vector2
var right_interpolate: float

@export var foot_overshoot_factor:float = 0.3
@export var foot_step_speed_left:float = 25.0
@export var foot_step_speed_right:float = 25.0
@export var hip_width = 8.0
var is_body_balanced: bool = true
var can_left_leg_move : bool = false
var can_right_leg_move : bool = false

func _ready() -> void:
	movement_node.assert_parent(self)
	
	levitation_raycast.target_position.y = levitationDistance
	
	target_leg_right.position.x = self.position.x + hip_width *-1
	target_leg_left.position.x = self.position.x + hip_width
	
	foot_left_start_position = target_leg_left.position
	foot_left_mid_position = target_leg_left.position
	foot_left_end_position = target_leg_left.position
	
	foot_right_start_position = target_leg_right.position
	foot_right_end_position = target_leg_right.position
	
func _physics_process(delta: float) -> void:

	levitation_raycast.force_raycast_update()
	target_leg_right.position.y = cast_contact_point.y
	target_leg_left.position.y = cast_contact_point.y
	
	floor_check()
	levitation(delta)
	move_direction = input_node.get_input()
	movement_node.move(delta)
	breathing_animation(delta)
	
	$RayCast2D/ray_target.global_position = cast_contact_point
	desired_step_l.position = cast_contact_point + Vector2(hip_width, 0)
	desired_step_r.position = cast_contact_point + Vector2(-hip_width, 0)
	
	var can_leg_moving_l : bool = false
	var can_leg_moving_r : bool = true
	if target_leg_right.position.distance_to(desired_step_r.position) > hip_width * 2 and can_leg_moving_r:
		target_leg_right.position = desired_step_r.position
		can_leg_moving_l = true
		can_leg_moving_r = false
	if target_leg_left.position.distance_to(desired_step_l.position) > hip_width * 2.25 and can_leg_moving_l:
		target_leg_left.position = desired_step_l.position
		can_leg_moving_r = true
		can_leg_moving_l = false

	
	
	#check_if_body_balanced()
	#
	#if right_interpolate > 1.0 and left_interpolate > right_interpolate:
		#can_left_leg_move = false
	#else: can_left_leg_move = true
	#
	#if left_interpolate > 1.0 and right_interpolate > left_interpolate:
		#can_right_leg_move = false
	#else:
		#can_right_leg_move = true
#
	#if !is_body_balanced and left_interpolate > 1.0 and can_left_leg_move:
		#calculate_new_step_left()
	#if !is_body_balanced and right_interpolate > 1.0 and can_right_leg_move:
		#calculate_new_step_right()	
	#
	#var eased_interpolate_left:float = ease_in_out_cubic(left_interpolate)
	#var eased_interpolate_right:float = ease_in_out_cubic(right_interpolate)
	#
	#target_leg_left.position = lerp(lerp(foot_left_start_position, foot_left_mid_position, eased_interpolate_left), lerp(foot_left_mid_position, foot_left_end_position, eased_interpolate_left), eased_interpolate_left)
	#target_leg_right.position = lerp(foot_right_start_position, foot_right_end_position, eased_interpolate_right)
	#
	#left_interpolate += delta * foot_step_speed_left
	#right_interpolate += delta * foot_step_speed_right


func check_if_body_balanced():
	is_body_balanced = check_is_float_inrange(self.position.x, target_leg_right.position.x - hip_width, target_leg_right.position.x - hip_width)
	
func check_is_float_inrange(val:float, bound1:float, bound2:float) -> bool:
	var min_val:float = min(bound1, bound2);
	var max_val:float = max(bound1, bound2);
	return val > min_val && val < max_val

func ease_in_out_cubic(x:float) -> float:
	return 1.0/ (1 + exp(-10 * (x - 0.5)))

func calculate_new_step_left():
	foot_left_start_position = target_leg_left.global_position
	left_interpolate = 0.0
	var position_difference_left = (cast_contact_point - target_leg_left.global_position) * (1 + foot_overshoot_factor)
	foot_left_end_position = target_leg_left.global_position + position_difference_left + Vector2(hip_width, 0)
	
	var step_size_left = foot_left_start_position.distance_to(foot_left_end_position)
	foot_left_mid_position = foot_left_start_position + position_difference_left / 2.0 - Vector2(0, step_size_left)

func calculate_new_step_right():
	foot_right_start_position = target_leg_right.global_position
	right_interpolate = 0.01
	var position_difference_right = (cast_contact_point - target_leg_right.global_position) * (1 + foot_overshoot_factor)
	foot_right_end_position = target_leg_right.global_position + position_difference_right - Vector2(hip_width, 0)
	
## ^^ REGION step updater

func lev_ray_collision_check()->Dictionary:

	var isColliding : bool = false
	var collisionPosition : Vector2  = Vector2.ZERO
	var collisionDistance : float = 0.0
	var collisionNormal :Vector2  = Vector2.ZERO
	var collisionSlope : float = 0.0
	var collisionBody = null
	var collisionBodyVel = Vector2.ZERO

	if levitation_raycast.is_colliding():

		isColliding = true
		collisionPosition = levitation_raycast.get_collision_point()
		collisionDistance = global_position.distance_to(collisionPosition)
		collisionNormal = levitation_raycast.get_collision_normal()
		collisionSlope =  rad_to_deg(acos(collisionNormal.dot(Vector2.UP)))
		collisionBody = levitation_raycast.get_collider()
		#
		#if collisionBody is RigidBody3D:
			#
			#collisionBodyVel = get_velocity_at_position(collisionBody, collisionPosition)
			
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

func floor_check()->void:
	
	var maxFloorDot : float = cos(deg_to_rad(max_floor_angle))
	
	isOnFloor = false
	floorNormal = Vector2.ZERO
	floorSlope = 0.0
	
	if !lev_ray_collision_check().isColliding:return

	if !lev_ray_collision_check().collisionNormal.dot(Vector2.UP) > maxFloorDot:return
		
	
	isOnFloor = true
	floorNormal = lev_ray_collision_check().collisionNormal
	floorSlope = rad_to_deg(acos(floorNormal.dot(Vector2.UP)))
	
	#if lev_ray_collision_check().collisionBody is RigidBody3D:
		#
		#var body : CollisionObject3D = ground_check().collisionBody
		#var contactPosition : Vector2 = ground_check().collisionPosition
		
	
	return

# Levitation and snap code.
func levitation(delta)->void:
	
	#If the ray is not colliding anymore remove the snap distance.
	if !lev_ray_collision_check().isColliding:
		
		levitation_raycast.target_position.y = levitationDistance
		
		return
	cast_contact_point = lev_ray_collision_check().collisionPosition
	#Final snap distance
	
	var relYVel : float = linear_velocity.y - lev_ray_collision_check().collisionBodyVel.y
	var snapDistMultiplier : float = linear_velocity.y * snapDistanceMultiplier
	
	snapDistMultiplier = clamp(snapDistMultiplier, 0, 1)
	
	var finalSnapDistance : float = snapDistance - snapDistance * snapDistMultiplier
	
	levitation_raycast.target_position.y = levitationDistance - finalSnapDistance
	
	#Levitation spring
	var offset : float = lev_ray_collision_check().collisionDistance - levitationDistance
	var stiffness : float = -offset * levitationStiffness
	var damp : float = relYVel * levitationDamp
	var springForce : float = stiffness + damp

	#If we are under the levitation distance, push up.
	if offset < 0:
		
		apply_central_force(Vector2.UP * springForce * mass)
		
		#Apply force to the object we are standing on.
		if lev_ray_collision_check().collisionBody is RigidBody2D:
			
			var body : RigidBody2D = lev_ray_collision_check().collisionBody
			var contactPosition : Vector2 = lev_ray_collision_check().collisionPosition
			var staticForce : float =  mass * 5
			var dynamicForce : float  = clamp(-relYVel, 0 , INF) * mass * 5
			var finalForce : Vector2 = Vector2.DOWN * (staticForce + dynamicForce)
			
			body.apply_force(finalForce, contactPosition -  body.position)
		
		return 
		
	#Check if there is a free path to snap.
	var characterHalfSize : float = $CollisionShape2D.shape.height / 2
	var castDistance : float = (lev_ray_collision_check().collisionDistance - characterHalfSize) * 0.9
	var canSnap : bool = not test_move(self.global_transform, Vector2.DOWN * castDistance)
	
	#If we are above the levitation distance but the ray hits floor, push down.
	if isOnFloor and canSnap:
		
		apply_central_force(Vector2.UP * springForce * mass)

func breathing_animation(delta):
	var bob_position: float = 0.0
	
	#if self.linear_velocity.x != 0: # if moving
		#bob_position = bobbing.calculate_value(delta,4.0,6.0)	
	#else:
		#bob_position = bobbing.calculate_value(delta,2, 5.0)	
	$torso.position.y = lerpf($torso.position.y,bob_position,0.75)
	$leg.position.y = lerpf($leg.position.y,bob_position,0.75)
