#move_set_bishop
extends  class_chess_move_set

var step_size: int = 1

var bishop_move_set = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]

func get_legal_move(current_position:Vector2) -> Array:
	var legal_move := []
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	
	if move_array_size == 0: # first step
		for direction in bishop_move_set:
			for i in range(1, util.root.data_instance.game_data.board_data.size):  # Up to 7 squares in any direction
				var new_pos = current_position + direction * i
				if is_within_board(new_pos):
					legal_move.append(new_pos)
				else:
					break
	return legal_move