extends ui_btn_change_scene

func _ready():
	game_node = util.root.game_instance.game.very_leafy_place.game_node.game
	ui_node = null
	data_node = null
