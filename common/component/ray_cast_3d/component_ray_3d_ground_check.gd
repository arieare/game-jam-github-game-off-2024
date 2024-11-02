extends Node
class_name component_ray_3d_ground_check
var ray_parent: RayCast3D

var floor_normal: Vector3 = Vector3.UP
var floor_slope: float = 0.0
var max_floor_angle: float = 46

func on_ground_check()-> bool:
	var max_floor_dot: float = cos(deg_to_rad(max_floor_angle))
	
	var is_on_floor: bool = false
	floor_normal = Vector3.ZERO
	floor_slope = 0.0
	
	if !ray_parent.collision.is_colliding: return false
		
	if !ray_parent.collision.col_normal.dot(Vector3.UP) > max_floor_dot: return false
		
	is_on_floor = true
	floor_normal = ray_parent.collision.col_normal
	floor_slope = rad_to_deg(acos(floor_normal.dot(Vector3.UP)))
	
	if ray_parent.collision.col_body is RigidBody3D:
		var body: CollisionObject3D = ray_parent.collision.col_body
		var contact_position: Vector3 = ray_parent.collision.col_position
	
	return is_on_floor
