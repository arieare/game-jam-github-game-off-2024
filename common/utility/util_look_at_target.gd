class_name util_look_at_target extends Node

func look_at_target(aim, actor, weight: float):
	var look_direction = Vector3(aim.global_position.x, actor.global_position.y + 0.2, aim.global_position.z)
	var xform: Transform3D = actor.global_transform # your transform
	xform = xform.looking_at(look_direction,Vector3.UP)
	actor.global_transform = actor.global_transform.interpolate_with(xform,weight)	

func face_direction(direction, actor):
	if actor.transform.origin != actor.global_position + direction:
		actor.rotation.y = lerp_angle(actor.rotation.y, atan2(-actor.linear_velocity.x, -actor.linear_velocity.z), 0.75)	
		actor.rotation.x = lerp_angle(actor.rotation.x, 0, 0.9)
		actor.rotation.z = 0

func safe_look_at(node : Node3D, target : Vector3) -> void:
	var origin : Vector3 = node.global_transform.origin
	var v_z := (origin - target).normalized()

	# Just return if at same position
	if origin == target:
		return

	# Find an up vector that we can rotate around
	var up := Vector3.ZERO
	for entry in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
		var v_x : Vector3 = entry.cross(v_z).normalized()
		if v_x.length() != 0:
			up = entry
			break

	# Look at the target
	if up != Vector3.ZERO:
		node.look_at(target, up)
