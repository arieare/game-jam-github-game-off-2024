@tool
extends Node3D

@onready var cam : Camera3D = world.world_cam

#func _input(event):
#	get_look_direction()

func get_look_direction() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos_2d = get_viewport().get_mouse_position()
	var ray_origin = cam.project_ray_origin(mouse_pos_2d)
	var ray_end = ray_origin + cam.project_ray_normal(mouse_pos_2d) * 2000 #arbitrary ray length
	var ray_array = space_state.intersect_ray(ray_origin, ray_end)
	if ray_array.has("position"):
#		print(ray_array["collider"].name)
		if ray_array["collider"].name != "player":
			return ray_array["position"]
	return Vector3.ZERO
#	var drop_plane  = Plane(Vector3(0, 0, 10), 0.5)
#	var mouse_pos_3d = drop_plane.intersects_ray(cam.project_ray_origin(mouse_pos_2d),cam.project_ray_normal(mouse_pos_2d))
#	drop_plane.intersects_segment()
#	print(mouse_pos_3d)
#	return mouse_pos_3d
