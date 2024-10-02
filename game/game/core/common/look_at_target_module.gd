extends Node
class_name CommonLookAtTarget

func look_at_target(aim, actor, weight: float):
	var look_direction = Vector3(aim.global_position.x, actor.global_position.y + 0.2, aim.global_position.z)
	var xform: Transform3D = actor.global_transform # your transform
	xform = xform.looking_at(look_direction,Vector3.UP)
	actor.global_transform = actor.global_transform.interpolate_with(xform,weight)	

#func face_direction(direction, actor):
	#if actor.transform.origin != actor.global_position + direction:
		#actor.rotation.y = lerp_angle(actor.rotation.y, atan2(-actor.linear_velocity.x, -actor.linear_velocity.z), 0.75)	
		#actor.rotation.x = lerp_angle(actor.rotation.x, 0, 0.9)
		#actor.rotation.z = 0
		#parent.rotation.z = 0
