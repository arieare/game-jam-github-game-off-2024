extends Node3DPlus
class_name module_aim_cursor

func aim_follow_cursor(cursor:Variant, cam:Camera3D, viewport: Viewport):
	var mouse_ray_cast = global.mouse_raycast.cast(cam, viewport)
	if mouse_ray_cast:
		cursor.global_position.x = mouse_ray_cast.position.x
		cursor.global_position.y = mouse_ray_cast.position.y
		cursor.global_position.z = mouse_ray_cast.position.z	
