extends Button

func _process(delta: float) -> void:
	var move_set = util.root.data_instance.game_data.move_step
	if move_set.size() < util.root.data_instance.game_data.chess_piece.movement_strategy.step_size or util.root.data_instance.game_data.chess_piece.is_moving:
		self.hide()
	else:
		self.show()
		if Input.is_action_just_pressed("move"):
			util.root.data_instance.game_data.chess_piece.parse_movement()

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed and !util.root.data_instance.game_data.chess_piece.is_moving:
		util.root.data_instance.game_data.chess_piece.parse_movement()
