extends Node
class_name component_ray_3d_levitate
var ray_parent: RayCast3D

@export var LEV_DISTANCE: float = 1.1
var LEV_STIFFNESS: float = 200
var LEV_DAMP: float = 13

#Snapping value
var snap_distance: float = 1
var snap_distance_multiplier: float = 0.1


func levitate_actor(delta, actor):
	ray_parent.force_raycast_update()
	
	if !ray_parent.collision.is_colliding:
		ray_parent.target_position.y = -LEV_DISTANCE
		return
	
	var relative_y_velocity: float = actor.linear_velocity.y - ray_parent.collision.col_body_velocity.y
	var snap_distance_multiplier_b: float = actor.linear_velocity.y * snap_distance_multiplier
	snap_distance_multiplier_b = clamp(snap_distance_multiplier_b, 0, 1)
	var final_snap_distance: float = snap_distance - snap_distance * snap_distance_multiplier_b
	
	ray_parent.target_position.y = -LEV_DISTANCE - final_snap_distance
	
	#Levitation spring
	var offset: float = ray_parent.collision.col_distance - LEV_DISTANCE
	var stiffness: float = -offset * LEV_STIFFNESS
	var dampness: float = relative_y_velocity * LEV_DAMP
	var spring_force: float = stiffness - dampness

	#If we are under the levitation distance, push up.
	if offset < 0:
		actor.apply_central_force(Vector3.UP * spring_force * actor.mass)
		
		#Apply force to the object we are standing on.
		if ray_parent.collision.col_body is RigidBody3D:
			var static_force: float =  actor.mass * 5
			var dynamic_force: float  = clamp(-relative_y_velocity, 0 , INF) * actor.mass * 5
			var final_force: Vector3 = Vector3.DOWN * (static_force + dynamic_force)
			ray_parent.collision.col_body.apply_force(final_force, ray_parent.collision.col_position -  ray_parent.collision.col_body.position)
		
		return 	
	
	#Check if there is a free path to snap.
	var parent_half_size: float = actor.collider.shape.height / 2
	var cast_distance: float = (ray_parent.collision.col_distance - parent_half_size) * 0.9
	var is_can_snap: bool = not actor.test_move(actor.global_transform, Vector3.DOWN * cast_distance)
	
	#If we are above the levitation distance but the ray hits floor, push down.
	if ray_parent.is_on_floor and is_can_snap:
		actor.apply_central_force(Vector3.UP * spring_force * actor.mass)
