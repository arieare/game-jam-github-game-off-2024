#move_set_knight
extends  class_chess_move_set

var step_size: int = 2

var knight_move_set = [Vector2(2, 1), Vector2(2, -1), Vector2(-2, 1), Vector2(-2, -1), Vector2(1, 2), Vector2(1, -2), Vector2(-1, 2), Vector2(-1, -2)]
var knight_one_tile_move_set = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
var knight_two_tile_move_set = [Vector2(2, 0), Vector2(-2, 0), Vector2(0, 2), Vector2(0, -2)]
var knight_all_two_tile_move_set = [Vector2(2, 0), Vector2(-2, 0), Vector2(0, 2), Vector2(0, -2),Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]


func get_legal_move(current_position:Vector2) -> Array:
	var legal_move := []
	var move_array_size = util.root.data_instance.game_data.move_step.size()
	
	if move_array_size == 0: # first step
		consult_knight_legal_move(legal_move,knight_all_two_tile_move_set,current_position, false)	
	if move_array_size == 1: # second step
		if chess_piece.max_move_step == 2:
			consult_knight_legal_move(legal_move,knight_two_tile_move_set,current_position, true)		
		if chess_piece.max_move_step == 1:
			consult_knight_legal_move(legal_move,knight_one_tile_move_set,current_position, true)
	return legal_move
#
func consult_knight_legal_move(returned_move_set: Array, move_set: Array, current_position_index: Vector2, with_perpendicular_check: bool):
	var next_x: int
	var next_y: int	
	for move in move_set:
		next_x = current_position_index.x + move[0]
		next_y = current_position_index.y + move[1]
		if is_within_board(Vector2(next_x,next_y)):
			if with_perpendicular_check:
				var check_perpendicular_square = Vector2(next_x,next_y).direction_to(chess_piece.current_square_index)
				if  check_perpendicular_square != Vector2(-1,0) and check_perpendicular_square != Vector2(0,-1) and check_perpendicular_square != Vector2(1,0) and check_perpendicular_square != Vector2(0,1):					
					returned_move_set.append(Vector2(next_x, next_y))	
			else:
				returned_move_set.append(Vector2(next_x, next_y))	

func get_steps_between() -> Array:
	var complete_move_set := []
	var move_set = util.root.data_instance.game_data.move_step
	var current_index = util.root.data_instance.game_data.chess_piece.current_square_index
	
	var calculating_set := [current_index]
	for index in move_set:
		calculating_set.append(index)	
	
	for step in calculating_set.size() - 1:
		var delta = calculating_set[step+1] - calculating_set[step]
		var step_count = abs(delta.x + delta.y)
		var additional_step: Vector2
		
		if step_count == 2:
			if delta.x > 0:
				additional_step = Vector2(calculating_set[step+1].x-1,calculating_set[step+1].y)
			elif delta.x < 0:
				additional_step = Vector2(calculating_set[step+1].x+1,calculating_set[step+1].y)
			elif delta.y > 0:
				additional_step = Vector2(calculating_set[step+1].x,calculating_set[step+1].y-1)
			elif delta.y < 0:
				additional_step = Vector2(calculating_set[step+1].x,calculating_set[step+1].y+1)			
			
			complete_move_set.append(additional_step)
		complete_move_set.append(calculating_set[step+1])
	
	return complete_move_set
