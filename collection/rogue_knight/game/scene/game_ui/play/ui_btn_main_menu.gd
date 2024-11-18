extends ui_btn_change_scene
@export var btn_label: RichTextLabel

func _ready():
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "purple_secondary", "small", false, true)
	game_node = null
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.main_menu
	#data_node = null

func scene_update():
	super()
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.STARTING
