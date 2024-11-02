#move_set_rook
extends  class_chess_move_set

var step_size: int = 1

var rook_move_set = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

func get_legal_move(current_position:Vector2) -> Array:
	var legal_move := []
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	
	if move_array_size == 0: # first step
		for direction in rook_move_set:
			for i in range(1, util.root.data_instance.game_data.board_data.size):  # Up to 7 squares in any direction
				var new_pos = current_position + direction * i
				if is_within_board(new_pos):
					legal_move.append(new_pos)
				else:
					break
	return legal_move

#func calculate_movement_step() -> Array:
	#var complete_move_set := []
	#var move_set = util.root.data_instance.game_data.move_step
	#var current_index = util.root.data_instance.game_data.chess_piece.current_square_index
	#
	#var calculating_set := [current_index]
	#for index in move_set:
		#calculating_set.append(index)	
	#
	#for step in calculating_set.size() - 1:
		#var delta = calculating_set[step+1] - calculating_set[step]
		#var step_count = abs(delta.x + delta.y)
		#var additional_step: Vector2
		#
		#for new_step in step_count-1:#if step_count == 1:
			#if delta.x > 0:
				#additional_step = Vector2(calculating_set[step+1].x-1,calculating_set[step+1].y)
				#print(calculating_set)
			#elif delta.x < 0:
				#additional_step = Vector2(calculating_set[step+1].x+1,calculating_set[step+1].y)
			#elif delta.y > 0:
				#additional_step = Vector2(calculating_set[step+1].x,calculating_set[step+1].y-1)
			#elif delta.y < 0:
				#additional_step = Vector2(calculating_set[step+1].x,calculating_set[step+1].y+1)			
				#
			#complete_move_set.append(additional_step)
		#complete_move_set.append(calculating_set[step+1])
	#
	#return complete_move_set


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
