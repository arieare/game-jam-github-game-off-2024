extends Button

@export var btn_label: RichTextLabel
@export var badge_label: PanelContainer

func _ready() -> void:
	#self.top_level
	util.root.data_instance.stylesheet.button_styler(self, btn_label, "red_secondary", "medium", false, false)
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	self.hide()
	badge_label.hide()
	if util.root.data_instance.is_tutorial_flag:
		badge_label.show()	

func _process(delta: float) -> void:
	
	var move_set = util.root.data_instance.game_data.move_step
	if move_set.size() == 0 or util.root.data_instance.game_data.chess_piece.is_moving:
		self.hide()
	else:
		#var selected_tile_position = util.root.data_instance.game_data.board_data.board_array[int(move_set[move_set.size()-1].x)][int(move_set[move_set.size()-1].y)].global_position
		#var new_pos = get_viewport().get_camera_3d().unproject_position(selected_tile_position)
		#self.global_position = Vector2(new_pos.x - self.size.x/2 - 36, new_pos.y - 84)
		self.show()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed and !util.root.data_instance.game_data.chess_piece.is_moving:
		util.root.data_instance.game_data.current_cam.shake_node.shake(0.035)
		util.root.data_instance.audio.sfx_dictionary.tile_select_deny.sfx.play()		
		util.root.data_instance.game_data.chess_piece.remove_move()
		if util.root.data_instance.game_data.chess_piece.curve_hint != [] and util.root.data_instance.is_tutorial_flag:
			for meshes in util.root.data_instance.game_data.chess_piece.curve_hint:
				meshes.queue_free()
			util.root.data_instance.game_data.chess_piece.curve_hint.clear()		

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.PLAYING:
			self.show()
		util.root.data_instance.GAME_STATE.PLANNING:
			self.hide()
