class_name class_chess_move_set

var chess_piece: Node3D
var board_boundary_size = Vector2(util.root.data_instance.game_data.board_data.size, util.root.data_instance.game_data.board_data.size)

func get_legal_move(current_position: Vector2) -> Array:
	#get legal moves
	return []

func is_within_board(chess_tile: Vector2) -> bool:
	return chess_tile.x >= 0 and chess_tile.x < board_boundary_size.x and chess_tile.y >= 0 and chess_tile.y < board_boundary_size.y

func get_steps_between() -> Array:
	var complete_move_set := []
	var move_set = util.root.data_instance.game_data.move_step
	var current_index = util.root.data_instance.game_data.chess_piece.current_square_index
	
	var calculating_set := [current_index]
	for index in move_set:
		calculating_set.append(index)	
	
	var start = calculating_set[0]
	var end = calculating_set[1]
		
	var steps = []
	
	# Determine the direction of movement
	var x_step = 0
	var y_step = 0
	
	if start.x != end.x:
		x_step = 1 if end.x > start.x else -1
	if start.y != end.y:
		y_step = 1 if end.y > start.y else -1
	
	# Check if the movement is valid (horizontal, vertical, or diagonal)
	if (x_step != 0 and y_step == 0) or (x_step == 0 and y_step != 0) or (abs(start.x - end.x) == abs(start.y - end.y)):
		var current_pos = start + Vector2(x_step, y_step)
		
		# Append all steps until we reach the end position
		while current_pos != end:
			steps.append(current_pos)
			current_pos += Vector2(x_step, y_step)
	steps.append(calculating_set[1])

	return steps
