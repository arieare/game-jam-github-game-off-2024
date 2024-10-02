extends Node
class_name Cam

'''must have camera3d child'''

var parent_cam

func assert_cam_parent(parent):
	parent_cam = parent
