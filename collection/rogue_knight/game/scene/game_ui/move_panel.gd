extends BoxContainer

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLAYING:
		self.hide()
	else:
		self.show()
