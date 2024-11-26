extends MeshInstance3D

func _physics_process(delta: float) -> void:
	self.rotation_degrees.y += 0.3
