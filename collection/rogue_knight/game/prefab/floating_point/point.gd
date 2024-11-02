extends Label3D

var spawn_tween: Tween

func _ready() -> void:
	tween_spawn()


func tween_spawn():
	spawn_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	spawn_tween.tween_property(self,"scale", Vector3(1.2,1,1.2),0.05)
	
	spawn_tween.tween_property(self,"position:y",position.y+1.5,0.5)
	
	spawn_tween.tween_property(self,"scale", Vector3(0.5,1,0.5),0.05)
