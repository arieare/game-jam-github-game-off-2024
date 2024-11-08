extends BoxContainer

@export var button_box: BoxContainer


func _ready() -> void:
	button_box.top_level
	
func _process(delta: float) -> void:

	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLAYING:
		self.hide()
	else:
		self.show()
		
	var move_set = util.root.data_instance.game_data.move_step
	if move_set.size() == 0 or util.root.data_instance.game_data.chess_piece.is_moving:
		button_box.hide()
				
	else:
		var board_half_size = floori(util.root.data_instance.game_data.board_data.size/2)
		
			
		var selected_tile_position = util.root.data_instance.game_data.board_data.board_array[int(util.root.data_instance.game_data.board_data.size - 1)][int(board_half_size)].global_position
		#var selected_tile_position = util.root.data_instance.game_data.board_data.board_array[int(move_set[move_set.size()-1].x)][int(move_set[move_set.size()-1].y)].global_position
		var new_pos = get_viewport().get_camera_3d().unproject_position(selected_tile_position)
		
		if util.root.data_instance.game_data.board_data.size/2 % 2 == 0:
			button_box.global_position = Vector2(new_pos.x - button_box.size.x +  button_box.size.x/4 - 16, new_pos.y + 84)
		else:
			button_box.global_position = Vector2(new_pos.x - button_box.size.x/2, new_pos.y + 84)
		button_box.show()
