extends ui_btn_change_scene

func _ready():
	game_node = util.root.game_instance.game.the_tiny_tale.game_node.game
	ui_node = null
	data_node = null
