extends Control

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING and util.root.data_instance.game_data.current_level > 2:
		self.show()
	else:
		self.hide()	
