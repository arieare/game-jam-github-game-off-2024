extends Node3DPlus

func _process(delta: float) -> void:
	global.aim_cursor.aim_follow_cursor(self, get_viewport().get_camera_3d(), get_viewport())
