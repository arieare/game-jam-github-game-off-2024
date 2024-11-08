extends Node3D
var child_mesh:MeshInstance3D
func _ready() -> void:
	child_mesh = self.get_child(0)
	var tween_spawn = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_spawn.tween_property(child_mesh,"scale",Vector3(1.45,1,1.45),0.15)			
	tween_spawn.tween_interval(0.05)
	tween_spawn.tween_property(child_mesh,"scale",Vector3(1,1,1),0.1)			
	
func _process(delta: float) -> void:
	animate_floating(delta, 1)

	pass

func animate_floating(delta, scale):
	var frequence = 2 # sin speed 2.5
	var amplitude = 1 # value range=
	if util.bob_sine.calculate(delta, frequence, amplitude) < - amplitude + 0.1: #left

		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(child_mesh,"transparency",0,0.5)		
	if util.bob_sine.calculate(delta, frequence, amplitude) > amplitude - 0.1: #right	
		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(child_mesh,"transparency",0.5,0.5)	
