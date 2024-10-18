class_name component_cam_follow extends Node

var follow_dampen: float = 0.05

func follow_cam(cam_pod, target, offset:Vector3):
	cam_pod.global_position = lerp(cam_pod.global_position, target.global_position, follow_dampen)
