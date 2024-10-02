extends Cam
class_name CamFreeLook

var free_look_speed_degree: float = 3.0

func rotate_cam():
	if Input.is_action_pressed("cam_rotate_left"):
		self.get_parent().get_parent().rotation_degrees.y += free_look_speed_degree 
	elif Input.is_action_pressed("cam_rotate_right"):
		self.get_parent().get_parent().rotation_degrees.y -= free_look_speed_degree
