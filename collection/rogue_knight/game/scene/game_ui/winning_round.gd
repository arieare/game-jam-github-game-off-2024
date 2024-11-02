extends CanvasLayer

func _ready() -> void:
	self.hide()
	
func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.WINNING:
		self.show()
	else:
		self.hide()
