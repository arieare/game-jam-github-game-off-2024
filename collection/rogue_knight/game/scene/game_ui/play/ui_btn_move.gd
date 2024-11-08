extends Button

@export var btn_label: RichTextLabel

var move_set: Array

func _ready() -> void:
	#self.top_level	
	util.root.data_instance.button_styler(self, btn_label, "purple", "medium", false, false)

func _process(delta: float) -> void:
	move_set = util.root.data_instance.game_data.move_step
	if move_set.size() < util.root.data_instance.game_data.chess_piece.movement_strategy.step_size or util.root.data_instance.game_data.chess_piece.is_moving:
		self.hide()
	else:

		#var selected_tile_position = util.root.data_instance.game_data.board_data.board_array[int(move_set[move_set.size()-1].x)][int(move_set[move_set.size()-1].y)].global_position
		#var new_pos = get_viewport().get_camera_3d().unproject_position(selected_tile_position)
		#self.global_position = Vector2(new_pos.x - self.size.x/2 + 36, new_pos.y - 84)
		self.show()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed or event.is_action_pressed("move") and !util.root.data_instance.game_data.chess_piece.is_moving and move_set.size() == util.root.data_instance.game_data.chess_piece.movement_strategy.step_size:
		util.root.data_instance.game_data.chess_piece.parse_movement()
