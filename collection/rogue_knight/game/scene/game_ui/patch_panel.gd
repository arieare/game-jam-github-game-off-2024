extends BoxContainer

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLANNING:
		self.hide()
