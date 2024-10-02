extends Button
class_name BtnPlay
var root 
@export var root_parent: Node2D

func _ready() -> void:
	root = get_tree().get_root().get_child(0)
	self.grab_focus()

func _process(_delta: float) -> void:
	if button_pressed:
		if $"../sfx_click".is_playing() == false:
			$"../sfx_click".play()
			
		root.emit_signal("change_scene_to_game")
	
