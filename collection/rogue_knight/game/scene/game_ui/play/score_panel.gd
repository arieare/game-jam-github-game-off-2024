extends BoxContainer

@export var point_row: BoxContainer
@export var move_row: BoxContainer
@export var money_row: BoxContainer

func _process(delta: float) -> void:
	match util.root.data_instance.current_game_state:
		util.root.data_instance.GAME_STATE.PLANNING:
			point_row.hide()
			move_row.hide()
		util.root.data_instance.GAME_STATE.PLAYING:
			self.show()
			point_row.show()
			move_row.show()
		util.root.data_instance.GAME_STATE.WINNING:
			self.show()
			point_row.show()
			move_row.show()						
		_:
			self.hide()
			point_row.hide()
			move_row.hide()			
