extends Control

func _ready():
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	self.hide()
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("shop"):
			if !util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].shop:
				self.hide()
			else:
				self.show()	

func _on_game_state_change(state):
	
	match state:
		util.root.data_instance.GAME_STATE.PLANNING:
			if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
				if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("shop"):
					self.hide()
					if !util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].shop:
						#print("hiding shop")
						self.hide()
					else:
						self.show()
		_:
			self.hide()
