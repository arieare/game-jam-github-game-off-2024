extends Node

var entity: RigidBody2D

#Walk values.
@export var max_speed: float = 700
@export var acceleration: float = 1400

#Jump values
@export var jumpSpeed: float = 5
@export var jumpHoldForce: float = 4.9
@export var jumpMinHoldTime: float = 0.25
@export var maxJumpTime: float = 0.75
@export var jumpDownSpeed: float = 5
@export var airControl: float = 0.5

func assert_parent(parent:RigidBody2D):
	entity = parent

func move(delta):
	if entity:
		#Acceleration multiplier
		var horizontal_velocity = entity.linear_velocity * Vector2(1, 0)
		
		## check if standing on moving platform
		#var horizontal_ground_velocity = entity.lev_ray_collision_check().collisionBodyVel * Vector2(1, 0)
		#var move_direction:Vector2 = (entity.move_direction * max_speed) + horizontal_ground_velocity
		
		var move_direction:Vector2 = (entity.move_direction * max_speed)
		
		var acceleration_goal = move_direction - horizontal_velocity
		var force_toward_acceleration = acceleration_goal / delta
		
		#Clamp force_toward_acceleration to our maximum allowed acceleration.
		if force_toward_acceleration.length() > acceleration:
			force_toward_acceleration = (force_toward_acceleration.normalized() * acceleration)

		entity.apply_force(force_toward_acceleration * entity.mass, Vector2(0,-0.025)) #hit the force slightly off-center to lean towards movement
		#apply_central_force(force_toward_acceleration * mass)
	else: return
