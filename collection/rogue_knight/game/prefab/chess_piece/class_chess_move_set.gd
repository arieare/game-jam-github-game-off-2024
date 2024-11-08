class_name class_chess_move_set

var chess_piece: Node3D
var board_boundary_size = Vector2(0,0)

func get_legal_move(current_position: Vector2) -> Array:
	#get legal moves
	return []

func is_within_board(chess_tile: Vector2) -> bool:
	board_boundary_size = Vector2(util.root.data_instance.game_data.board_data.size, util.root.data_instance.game_data.board_data.size)
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


func min_moves(move_set: Array, start: Vector2, target: Vector2, restricted_coords: Array) -> Dictionary:
	var queue_pos = [start]
	var queue_step = 0
	var queue_path = [start]
	var visited = {}
	visited[start] = true
	var restricted_set = {}
	for coord in restricted_coords:
		restricted_set[coord] = true

	var pos
	var step
	var path
	while queue_pos:
		pos = queue_pos.pop_front()
		step = 0
		path = queue_path.pop_front()
		
		print(pos)
		if pos == target:
			if path is Array:
				return {"moves": flatten_array(path).size()-1, "path": flatten_array(path)}

		for dir in move_set:
			var next_pos = pos + dir
			if is_within_board(Vector2(next_pos.x, next_pos.y)) and not visited.has(next_pos) and not restricted_set.has(next_pos):
				visited[next_pos] = true
				
				var new_path = [path]
				new_path.append(next_pos)
				
				queue_pos.append(next_pos)
				step += 1
				queue_path.append(new_path)

	return {"moves": -1, "path": []}  # If target is unreachable


func flatten_array(nested_array: Array) -> Array:
	var result = []
	
	for element in nested_array:
		if element is Array:
			# If the element is an array, recursively flatten it and append to result
			result += flatten_array(element)
		else:
			# If it's not an array, append the element directly
			result.append(element)
	return result

func subtract_array(array_a: Array, array_b: Array) -> Array:
	var clean_array = []
	
	for item in array_a:
		if item not in array_b:
			clean_array.append(item)
	
	return clean_array
