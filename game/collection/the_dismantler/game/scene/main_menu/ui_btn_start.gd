extends ui_btn_change_scene

func _ready():
	print(util.root.game_instance.the_dismantler.game.game_node)
	game_node = util.root.game_instance.the_dismantler.game.game_node.scene_0
	ui_node = null
	data_node = util.root.data_container.get_child(0)
