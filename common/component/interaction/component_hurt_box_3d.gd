class_name hurt_box_3d extends Area3D

var attack: Callable = func():
	pass

func _ready():
	self.connect("area_entered",_on_area_entered)
	
func _on_area_entered(area: Area3D) -> void:
	await self.attack.call(area.attack)
