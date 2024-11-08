extends BoxContainer

@export var point_row: BoxContainer
@export var move_row: BoxContainer
@export var money_row: BoxContainer

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state == util.root.data_instance.GAME_STATE.PLANNING:
		point_row.hide()
		move_row.hide()
	else:
		point_row.show()
		move_row.show()
