extends Control

func _ready():
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.PLANNING:
			self.hide()
			if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
				if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("shop"):
					if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].shop == true:
						self.show()
		_:
			self.hide()
