extends RichTextLabel

func _ready() -> void:
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.LOSING:
			if util.root.data_instance.game_data.shortest_move < 100:
				self.text = "[wave amp=20.0 freq=2.0 connected=1][color=CORAL]"+ str(util.root.data_instance.game_data.shortest_move) + "[/color][/wave]"	
			else:
				self.text = "[wave amp=20.0 freq=2.0 connected=1][color=CORAL]"+ "–" + "[/color][/wave]"	
