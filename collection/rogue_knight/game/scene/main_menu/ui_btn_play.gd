extends ui_btn_change_scene

@export var btn_label: RichTextLabel

func _ready():
	self.grab_focus()
	game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui

func scene_update():
	super()
	if util.root.data_instance.audio.sfx_dictionary.bgm_intro.sfx.playing:
		util.root.data_instance.audio.sfx_dictionary.bgm_intro.sfx.stop()
	if util.root.data_instance and !util.root.data_instance.audio.sfx_dictionary.bgm_in_game_1.sfx.playing:
		util.root.data_instance.audio.sfx_dictionary.bgm_in_game_1.sfx.play()		
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLANNING

func _process(delta: float) -> void:
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "big", false, false)
