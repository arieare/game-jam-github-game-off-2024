extends Cam
class_name CamFollowTarget

var follow_dampen: float = 0.05

func follow_cam(target, offset:Vector3):
	parent_cam.global_position = lerp(parent_cam.global_position, target.global_position, follow_dampen)
