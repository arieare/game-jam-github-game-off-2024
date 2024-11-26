extends ui_btn_change_scene
@export var btn_label: RichTextLabel

func _ready():
	self.grab_focus()
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "white", "small", false, true)
	game_node = util.root.game_instance.rogue_knight.game.game_node.scene_0
	ui_node = util.root.game_instance.rogue_knight.ui.ui_node.game_ui	

func scene_update():
	util.root.data_instance.game_data.current_position = Vector2.ZERO
	util.root.data_instance.game_data.money = 0
	util.root.data_instance.game_data.score = 0
	util.root.data_instance.game_data.multiplier = 0
	util.root.data_instance.game_data.max_move = 8
	util.root.data_instance.game_data.max_move_padding = 3
	util.root.data_instance.game_data.shortest_move = 100
	util.root.data_instance.game_data.initial_move = 0
	util.root.data_instance.game_data.move_step = []
	#util.root.data_instance.game_data.board_data = {
			#"size" = 4,
			#"target_position" = Vector2(0,0),
			#"board_array" ={},
			#"blocked_index" = [],
			#"starting_position" = Vector2(0,0)
		#}
	util.root.data_instance.game_data.patch_data = {}
	util.root.data_instance.game_data.patch_inventory = []
	util.root.data_instance.game_data.max_patch_inventory = 3
	util.root.data_instance.game_data.max_shop_size = 2
	util.root.data_instance.game_data.current_level = 1
	#util.root.data_instance.game_data.secret_string = "ROYAL BLOOM UNVEIL KARDINAL TRUTH"
	#util.root.data_instance.game_data.secret_string_array =[]
	util.root.data_instance.game_data.secret_string_cursor = 0	

	if util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.get_stream(0) == util.root.data_instance.audio.bgm_in_game_2:
		if !util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.playing:
			util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()	
	else:
		util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
		util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
		util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_in_game_2, 1.0)	
		util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()		
	
	super()
	util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLANNING


var is_it_hovered:=false
func _process(delta: float) -> void:
	if self.is_hovered() and !is_it_hovered:
		is_it_hovered = true
		util.root.data_instance.audio.sfx_dictionary.tile_hover.sfx.play()
		self.pivot_offset = self.size/2
		self.rotation_degrees = randf_range(-3,3)
	elif !self.is_hovered():
		is_it_hovered = false
		self.rotation_degrees = 0
