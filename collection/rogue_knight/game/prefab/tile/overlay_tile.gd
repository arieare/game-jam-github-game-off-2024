extends Node3D
var frequence = 0.0
func _ready() -> void:
	frequence = randf_range(0.01,0.02)
	
func _physics_process(delta: float) -> void:
	animate_floating(delta, 0.05)
	pass

func animate_floating(delta, scale):
	#var frequence = 0.5 # sin speed 2.5
	var amplitude = 0.1 # value range=
	if util.bob_sine.calculate(delta, frequence, amplitude) < - amplitude + 0.1: #left

		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(self,"position:y",self.position.y - scale,0.5)		
	if util.bob_sine.calculate(delta, frequence, amplitude) > amplitude - 0.1: #right	
		var tween_head = create_tween().set_trans(Tween.TRANS_SINE)
		tween_head.tween_property(self,"position:y",self.position.y + scale,0.5)	
