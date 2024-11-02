extends Node
class_name component_ray_3d_collision_check
var ray_parent: RayCast3D

func ray_collision_check()->Dictionary:
# returns a dictionary with information about the raycast
	var is_colliding: bool = false
	var col_position: Vector3  = Vector3.ZERO
	var col_distance: float = 0.0
	var col_normal: Vector3  = Vector3.ZERO
	var col_slope: float = 0.0
	var col_body = null
	var col_body_velocity: Vector3 = Vector3.ZERO

	if ray_parent.is_colliding():
		is_colliding = true
		col_position = ray_parent.get_collision_point()
		col_distance = ray_parent.global_position.distance_to(col_position)
		col_normal = ray_parent.get_collision_normal()
		col_slope =  rad_to_deg(acos(col_normal.dot(Vector3.UP)))
		col_body = ray_parent.get_collider()

		if col_body is RigidBody3D:
			pass
			#col_body_velocity = parent.get_velocity_at_position(col_body, col_position)

	var results: Dictionary = {
		"is_colliding": is_colliding,
		"col_position": col_position,
		"col_distance": col_distance,
		"col_normal": col_normal,
		"col_slope": col_slope,
		"col_body" : col_body,
		"col_body_velocity" : col_body_velocity}

	return results
