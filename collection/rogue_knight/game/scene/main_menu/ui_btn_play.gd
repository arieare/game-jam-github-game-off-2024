extends ui_btn_change_scene

@export var btn_label: RichTextLabel

func _ready():
	#util.connect("root_ready", _on_root_ready)
	game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui	
	self.grab_focus()
	self.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	#await util.root.ready
	#game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	#ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui

#func _on_root_ready(node):
	#print("root ready")

func scene_update():
	if game_node and ui_node:
		super()
		if util.root.data_instance: 
			if util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.get_stream(0) == util.root.data_instance.audio.bgm_in_game_1:
				if !util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.playing:
					util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()	
			else:
				util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
				util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
				util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_in_game_1, 1.0)	
				util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()			
		
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLANNING

var is_it_hovered:=false
func _process(delta: float) -> void:
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "big", false, false)
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
		self.pivot_offset = self.size/2
		self.rotation_degrees = randf_range(-3,3)
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0


func _on_pressed() -> void:
	util.root.data_instance.audio.sfx_dictionary.tile_select_confirm.sfx.play()
