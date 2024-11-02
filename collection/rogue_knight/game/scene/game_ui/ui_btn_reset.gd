extends Button

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLAYING
		util.root.data_instance.game_data.score = 0
		util.root.data_instance.game_data.max_move = 10
		
