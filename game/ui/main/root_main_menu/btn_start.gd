extends NodeButtonPlus

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		global.scene_manager._on_change_scene( root.node_list["ui"], root.ui_node["game_selection_menu"])
