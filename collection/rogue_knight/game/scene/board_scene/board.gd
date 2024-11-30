extends Node3D

var board_array : Dictionary = {}
var board_index : Dictionary = {}

func subtract_array(array_a: Array, array_b: Array) -> Array:
	var clean_array = []
	
	for item in array_a:
		if item not in array_b:
			clean_array.append(item)
	
	return clean_array

func generate_board(board_size:int):
	## Reset Variables
	if util.root.data_instance.instance_pool.board_tile_node.get_children():
		for i in util.root.data_instance.instance_pool.board_tile_node.get_children():
			i.name = "void"
			i.hide()
			i.reparent(util.root.data_instance.instance_pool.temp_board_tile_node)
			i.position = Vector3(99,99,99)

	board_array.clear()
	util.root.data_instance.game_data.patch_data.clear()
	util.root.data_instance.game_data.score = 0
	util.root.data_instance.game_data.board_data.board_array.clear()
	
	init_tile_position(board_size)
	

	var current_square
	var tile_count:= 0
	for i in board_size:
		var board_array_col : Dictionary = {}
		for j in board_size:
			if (i + j) % 2 == 0:
				#current_square = util.root.data_instance.instance_pool.white_tile_array[tile_count]
				current_square = util.root.data_instance.instance_pool.glass_white_tile_array[tile_count]
			else:
				#var random_tile = randi_range(0,1)
				#if random_tile == 0:
					#current_square = util.root.data_instance.instance_pool.black_tile_array[tile_count]
				#else:
				current_square = util.root.data_instance.instance_pool.glass_black_tile_array[tile_count]
			
			if i == util.root.data_instance.game_data.board_data.target_position.x and j == util.root.data_instance.game_data.board_data.target_position.y:
				current_square = util.root.data_instance.instance_pool.goal_tile_array[tile_count]
				util.root.data_instance.vfx.vfx_goal_tile.position = Vector3(j * 0.5,0,i* 0.5)
				
			
			current_square.position = Vector3(j * 0.5,0,i* 0.5)
			current_square.name = "square_" + str(i) + "_" + str(j)
			current_square.hide()
			tile_count += 1
			current_square.reparent(util.root.data_instance.instance_pool.board_tile_node)
			
			board_array_col[j] = current_square
			board_array[i] = board_array_col
			util.root.data_instance.game_data.board_data.board_array[i] = board_array_col
			
			board_index[current_square.name] = Vector2(i,j)
	
	var board_spawn_speed:= 0.05
	for i in board_size:
		for j in board_size:
			
			board_array[i][j].show()
			var hover_tween: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
			hover_tween.tween_property(board_array[i][j],"scale", Vector3(1.25,1,1.25),0.05)
			hover_tween.tween_property(board_array[i][j],"position:y",0.1,0.02)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:z", randf_range(-45.0, 45.0),0.2)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:x", randf_range(-45.0, 45.0),0.1)	
			hover_tween.tween_interval(0.2)
			hover_tween.tween_property(board_array[i][j],"scale", Vector3(1,1,1),0.05)
			hover_tween.tween_property(board_array[i][j],"position:y",0,0.03)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:z", 0.0,0.02)
			hover_tween.tween_property(board_array[i][j],"rotation_degrees:x", 0.0,0.02)
			
			util.root.data_instance.audio.sfx_dictionary.board_initialized.sfx.play()

			await get_tree().create_timer(board_spawn_speed - (i/2)).timeout
	
	for j in util.root.data_instance.game_data.board_data.blocked_index:
		await get_tree().create_timer(0.025).timeout
		board_array[int(j.x)][int(j.y)].hide()
		util.root.data_instance.audio.sfx_dictionary.typing.sfx.play()		
	
	util.root.data_instance.board_ready.emit()
	util.root.data_instance.vfx.vfx_goal_tile.emitting = true
	
	## Props
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].has("prop"):
			for key in util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].prop:
				if key == "sword":
					for pos in util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].prop.sword:
						util.root.data_instance.instance_pool.prop_sword_intance.position = board_array[int(pos.x)][int(pos.y)].position
						util.root.data_instance.instance_pool.prop_sword_intance.show()
			
func _ready() -> void:
	for prop in util.root.data_instance.instance_pool.prop_node.get_children():
		prop.hide()
	util.root.data_instance.instance_pool
	util.root.data_instance.connect("game_state_change", _on_game_state_change)
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		util.root.data_instance.game_data.board_data.size = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].board_size

	generate_board(util.root.data_instance.game_data.board_data.size)	


func _on_game_state_change(state):
	var board_size = util.root.data_instance.game_data.board_data.size
	match state:
		util.root.data_instance.GAME_STATE.BOARD_CRUMBLE:
			util.root.data_instance.vfx.vfx_goal_tile.emitting = false
			var board_spawn_speed:= 0.05
			for i in board_size:
				for j in board_size:
					var hover_tween: Tween = create_tween().set_trans(Tween.TRANS_CIRC)
					hover_tween.tween_property(board_array[i][j],"position:y",50,2.0)
					await get_tree().create_timer(board_spawn_speed - (i/2)).timeout	

func init_tile_position(board_size):
	## Set Starting Position, Goal Tile, and Obstacle Position	
	var board_vector_array	= []
	for i in board_size:
		for j in board_size:
			board_vector_array.append(Vector2(int(i),int(j)))
	### Check if level_data is set:
	if util.root.data_instance.level_data.has(util.root.data_instance.game_data.current_level):
		### Check obstacle
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].blocked_index != []:
			util.root.data_instance.game_data.board_data.blocked_index = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].blocked_index
			board_vector_array = subtract_array(board_vector_array, util.root.data_instance.game_data.board_data.blocked_index)
			#print("obstacle available:" + str(board_vector_array))
		else:
			util.root.data_instance.game_data.board_data.blocked_index = []
		
		### Check if both starting and goal is null
		if util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position == null and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position == null:
			util.root.data_instance.game_data.board_data.starting_position = board_vector_array.pick_random()
			board_vector_array.erase(util.root.data_instance.game_data.board_data.starting_position)	
			util.root.data_instance.game_data.board_data.target_position = board_vector_array.pick_random()	
			board_vector_array.clear()
			#print("both random")
		### Check if starting position is null
		elif util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position == null and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position != null:
			util.root.data_instance.game_data.board_data.target_position = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position
			board_vector_array.erase(util.root.data_instance.game_data.board_data.target_position)	
			util.root.data_instance.game_data.board_data.starting_position = board_vector_array.pick_random()
			board_vector_array.clear()
			#print("starting position random")
		### Check if target position is null
		elif util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position != null and util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position == null:
			util.root.data_instance.game_data.board_data.starting_position = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position
			board_vector_array.erase(util.root.data_instance.game_data.board_data.starting_position)	
			util.root.data_instance.game_data.board_data.target_position = board_vector_array.pick_random()	
			board_vector_array.clear()
			#print("target position random")
		### Check if both preset
		else:
			util.root.data_instance.game_data.board_data.starting_position = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].starting_position
			util.root.data_instance.game_data.board_data.target_position = util.root.data_instance.level_data[util.root.data_instance.game_data.current_level].target_position
			board_vector_array.clear()
			#print("both preset")	
