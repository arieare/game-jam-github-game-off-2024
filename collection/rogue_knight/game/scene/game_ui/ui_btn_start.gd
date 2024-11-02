extends Button

func _input(event: InputEvent) -> void:
	if !event.is_echo() and self.button_pressed:
		util.root.data_instance.current_game_state = util.root.data_instance.GAME_STATE.PLAYING
