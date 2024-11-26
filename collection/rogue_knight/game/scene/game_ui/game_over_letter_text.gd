extends RichTextLabel

func _ready() -> void:
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.LOSING:
			var collected_letter:String
			for i in util.root.data_instance.game_data.secret_string_cursor:
				collected_letter += util.root.data_instance.game_data.secret_string_array[i] + " "
			util.root.data_instance.game_data.secret_string_cursor = 0
			self.text = "[wave amp=20.0 freq=2.0 connected=1][color=GREEN_YELLOW]"+ collected_letter + "[/color][/wave]"	
