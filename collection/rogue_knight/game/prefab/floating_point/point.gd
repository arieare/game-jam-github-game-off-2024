extends Label3D

var spawn_tween: Tween

func _ready() -> void:
	self.hide()

func tween_spawn():
	spawn_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	
	spawn_tween.tween_property(self,"position:y",position.y+0.5,0.8)
	spawn_tween.tween_property(self,"scale", Vector3(1.8,1.8,1.8),0.3)
	
	#spawn_tween.tween_property(self,"scale", Vector3(0.5,1,0.5),0.05)
	await spawn_tween.finished
	self.hide()
	self.scale = Vector3(1,1,1)
