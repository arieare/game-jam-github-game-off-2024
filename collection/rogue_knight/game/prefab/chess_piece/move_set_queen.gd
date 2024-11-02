#move_set_queen
extends  class_chess_move_set

var step_size: int = 1

var queen_move_set = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1),
					  Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

func get_legal_move(current_position:Vector2) -> Array:
	var legal_move := []
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	
	if move_array_size == 0: # first step
		for direction in queen_move_set:
			for i in range(1, util.root.data_instance.game_data.board_data.size):  # Up to 7 squares in any direction
				var new_pos = current_position + direction * i
				if is_within_board(new_pos):
					legal_move.append(new_pos)
				else:
					break
	return legal_move

#func get_steps_between() -> Array:
	#var complete_move_set := []
	#var move_set = util.root.data_instance.game_data.move_step
	#var current_index = util.root.data_instance.game_data.chess_piece.current_square_index
	#
	#var calculating_set := [current_index]
	#for index in move_set:
		#calculating_set.append(index)	
	#
	#var start = calculating_set[0]
	#var end = calculating_set[1]
		#
	#var steps = []
	#
	## Determine the direction of movement
	#var x_step = 0
	#var y_step = 0
	#
	#if start.x != end.x:
		#x_step = 1 if end.x > start.x else -1
	#if start.y != end.y:
		#y_step = 1 if end.y > start.y else -1
	#
	## Check if the movement is valid (horizontal, vertical, or diagonal)
	#if (x_step != 0 and y_step == 0) or (x_step == 0 and y_step != 0) or (abs(start.x - end.x) == abs(start.y - end.y)):
		#var current_pos = start + Vector2(x_step, y_step)
		#
		## Append all steps until we reach the end position
		#while current_pos != end:
			#steps.append(current_pos)
			#current_pos += Vector2(x_step, y_step)
	#steps.append(calculating_set[1])
#
	#return steps
