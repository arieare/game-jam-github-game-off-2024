extends Node
class_name component_cam_free_look

var free_look_speed_degree: float = 3.0

func rotate_cam(cam_pod):
	if Input.is_action_pressed("cam_rotate_left"):
		cam_pod.rotation_degrees.y += free_look_speed_degree 
	elif Input.is_action_pressed("cam_rotate_right"):
		cam_pod.rotation_degrees.y -= free_look_speed_degree
