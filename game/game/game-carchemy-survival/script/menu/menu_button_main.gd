extends Button
class_name BtnMain
var root 
@export var root_parent: Node2D

func _ready() -> void:
	root = get_tree().get_root().get_child(0)

func _process(delta: float) -> void:
	if button_pressed:
		root.emit_signal("change_scene_to_main_menu")
	
