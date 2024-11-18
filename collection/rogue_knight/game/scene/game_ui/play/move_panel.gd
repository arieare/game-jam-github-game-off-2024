extends BoxContainer


func _ready() -> void:
	self.top_level
	
func _process(delta: float) -> void:
	var board_half_size = floori(util.root.data_instance.game_data.board_data.size/2)
	var selected_tile_position = util.root.data_instance.game_data.board_data.board_array[int(util.root.data_instance.game_data.board_data.size - 1)][int(board_half_size)].global_position
	var new_pos = get_viewport().get_camera_3d().unproject_position(selected_tile_position)
	#
	if util.root.data_instance.game_data.board_data.size % 2 == 0:
		self.global_position = Vector2(new_pos.x - self.size.x/2 - 48, new_pos.y + 84)
	else:
		self.global_position = Vector2(new_pos.x - self.size.x/2, new_pos.y + 84)
	self.show()
