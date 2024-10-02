extends Node3DPlus
var mouse_ray_cast

func aim_follow_cursor(cursor:Variant):
	mouse_ray_cast = root.common["mouse_ray_cast"].cast(root.cam.cam_child)
	if mouse_ray_cast:
		cursor.global_position.x = mouse_ray_cast.position.x
		cursor.global_position.y = mouse_ray_cast.position.y
		cursor.global_position.z = mouse_ray_cast.position.z	

func _process(delta: float) -> void:
	aim_follow_cursor(self)
