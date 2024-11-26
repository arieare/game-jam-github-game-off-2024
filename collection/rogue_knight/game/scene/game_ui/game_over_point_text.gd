extends RichTextLabel

func _ready() -> void:
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.LOSING:
			self.text = "[wave amp=20.0 freq=2.0 connected=1][color=DEEP_SKY_BLUE]"+ str(util.root.data_instance.game_data.high_score) + "[/color][/wave]"	
