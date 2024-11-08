extends ui_btn_change_scene

func _ready():
	game_node = null
	ui_node = util.root.game_instance["rogue_knight"].ui.ui_node.main_menu
	#data_node = util.root.game_instance["rogue_knight"].data
	#util.root.data_instance = util.root.data_container.get_child(0)

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		print("hello")
		#util.scene_manager.change( util.root.ui_container, util.root.game_instance[key].ui.ui_node.main_menu)
		#print(util.root.game_instance.data[key])
		util.scene_manager.change( util.root.data_container, util.root.game_instance["rogue_knight"].data)
		util.root.data_instance = util.root.data_container.get_child(0)
		scene_update()
