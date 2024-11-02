extends Node3D

func _process(delta: float) -> void:
	aim_follow_cursor(self, get_viewport().get_camera_3d(), get_viewport())

func aim_follow_cursor(cursor:Variant, cam:Camera3D, viewport: Viewport):
	var mouse_ray_cast = util.mouse.cast(cam, viewport)
	if mouse_ray_cast:
		cursor.global_position.x = mouse_ray_cast.position.x
		cursor.global_position.y = mouse_ray_cast.position.y
		cursor.global_position.z = mouse_ray_cast.position.z	
