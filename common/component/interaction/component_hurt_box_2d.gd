class_name hurt_box_2d extends Area2D

var attack: Callable = func():
	pass

func _ready():
	self.connect("area_entered",_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().size() > 0:
		await self.attack.call(area.attack)
