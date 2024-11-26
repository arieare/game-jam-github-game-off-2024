extends Control

@export var input_field:TextEdit

func _ready() -> void:
	self.hide()
	util.root.data_instance.connect("game_state_change", _on_game_state_change)

func _on_game_state_change(state):
	match state:
		util.root.data_instance.GAME_STATE.FINALE_2:
			self.show()
			input_field.grab_focus()
		_:
			self.hide()
