extends ui_btn_change_scene

func _ready():
	game_node = null
	ui_node = util.root.game_instance.ui._root.ui_node.game_select_menu
	data_node = null
