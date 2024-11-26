extends Label3D

var spawn_tween: Tween
@export var bg:MeshInstance3D

func _ready() -> void:
	self.hide()

func tween_spawn(color, text_color):
	self.modulate = text_color
	bg.mesh.material.albedo_color = color
	var random_x = randf_range(-0.5,0.5)
	spawn_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	
	spawn_tween.set_parallel(true)
	spawn_tween.tween_property(self,"position:y",position.y+1,0.8)
	spawn_tween.tween_property(self,"position:x",position.x+random_x,0.8)
	spawn_tween.set_parallel(false)
	spawn_tween.tween_property(self,"scale", Vector3(1.8,1.8,1.8),0.3)
	
	#spawn_tween.tween_property(self,"scale", Vector3(0.5,1,0.5),0.05)
	await spawn_tween.finished
	util.root.data_instance.audio.sfx_dictionary.point_spawned.sfx.play()
	self.hide()
	self.scale = Vector3(1,1,1)
