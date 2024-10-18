class_name ui_btn_change_scene extends Button

var game_node: PackedScene = null
var ui_node: PackedScene = null
var data_node: PackedScene = null

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		scene_update()
	
func scene_update():
	util.scene_manager.change( util.root.game_container, game_node)	
	util.scene_manager.change( util.root.ui_container, ui_node)
	util.scene_manager.change( util.root.data_container, data_node)
	pass


#util.scene_manager.change( util.root.game_container, util.root.game_instance.game.very_leafy_place.node)	
