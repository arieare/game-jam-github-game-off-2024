extends Node3D

var overlay_array := []
@export var board_node: Node3D
var move_hint

func spawn_legal_move_hint(square_index, legal_move_array: Array):
	clear_legal_move_hint()
	var overlay_count := 0
	for square in legal_move_array:
		if int(square.x) < util.root.data_instance.game_data.board_data.size and int(square.y) < util.root.data_instance.game_data.board_data.size: 
			#var overlay = util.root.data_instance.instance_pool.overlay_tile_array[overlay_count]
			#overlay.position = board_node.board_array[int(square.x)][int(square.y)].position
			#overlay.position.y = 0.15
			##self.get_parent().add_child.call_deferred(overlay)
			#overlay_array.append(overlay)
			#overlay.show()
			#overlay_count += 1	
			## show glow
			var mat = board_node.board_array[int(square.x)][int(square.y)].material
			#var mat = board_node.board_array[int(i)][int(j)].material
			if mat:
				var albedo = mat.albedo_color				
				var next_mat = mat.next_pass
				if next_mat:
					next_mat.set_shader_parameter("aura_color",Color(Color.GREEN,0.4))

func clear_legal_move_hint():
	for nodes in util.root.data_instance.instance_pool.overlay_tile_array:
		nodes.hide()
	util.root.data_instance.instance_pool.overlay_goal_tile_instance.hide()
	overlay_array.clear()
	#move_hint = null
	for i in board_node.board_array.size():
		for j in board_node.board_array[int(i)]:
			#print(board_node.board_array[int(i)][int(j)])
			var mat = board_node.board_array[int(i)][int(j)].material
			if mat:
				var albedo = mat.albedo_color				
				var next_mat = mat.next_pass
				if next_mat:
					next_mat.set_shader_parameter("aura_color",Color.TRANSPARENT)		

func spawn_target_move_hint(square_index):
	var overlay = util.root.data_instance.instance_pool.overlay_goal_tile_instance
	overlay.position = square_index.position
	overlay.position.y = 0.15
	overlay.show()
	overlay_array.append(overlay)	
	var tween_spawn = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween_spawn.tween_property(overlay,"scale",Vector3(1.45,1,1.45),0.15)			
	tween_spawn.tween_interval(0.05)
	tween_spawn.tween_property(overlay,"scale",Vector3(1,1,1),0.1)		
	move_hint = overlay
	

func _ready() -> void:
	clear_legal_move_hint()
	util.root.data_instance.connect("move_started", _on_move_started)

func _on_move_started():
	var move_tween: Tween
	if move_tween:
		move_tween.kill()
	move_tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	move_tween.tween_property(move_hint,"scale", Vector3(1.5,1,1.5),0.12)
	move_tween.tween_interval(0.1)
	move_tween.tween_property(move_hint,"scale", Vector3(0.1,1,0.1),0.06)
	await move_tween.finished
	clear_legal_move_hint()
