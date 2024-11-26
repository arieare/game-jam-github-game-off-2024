extends Control

func _ready() -> void:
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.TRUE_ENDING:
			self.show()
		_:
			self.hide()
