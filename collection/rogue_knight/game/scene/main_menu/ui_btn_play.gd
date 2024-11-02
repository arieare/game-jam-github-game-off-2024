extends ui_btn_change_scene


func _ready():
	game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui
	#data_node = null

func scene_update():
	super()
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLANNING
