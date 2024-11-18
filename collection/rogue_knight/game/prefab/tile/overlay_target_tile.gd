extends Node3D
var child_mesh:MeshInstance3D
func _ready() -> void:
	self.connect("visibility_changed", _on_show)
	var tween_spawn = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_spawn.tween_property(child_mesh,"scale",Vector3(1.45,1,1.45),0.15)			
	tween_spawn.tween_interval(0.05)
	tween_spawn.tween_property(child_mesh,"scale",Vector3(1,1,1),0.1)			
	
func _on_show():
	pass
