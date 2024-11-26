extends Node3D

@export var control: Node3D

var is_pick_up: bool = false
var picked_up_patch
@export var patch_tile:PackedScene
var patch_dictionary = {}

func _ready() -> void:
	util.root.data_instance.connect("patch_picked", _on_patch_picked)
	util.root.data_instance.connect("remove_patch_from_board", _on_remove_patch_from_board)

func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLANNING:
		return
	else:
		if is_pick_up and control.cast and !control.cast.collider.is_in_group("patch") and picked_up_patch != null:
			picked_up_patch.global_position = control.cast.position
			
			if !control.cast.collider.is_in_group("board"):
				var patch_rotate_tween: Tween
				if patch_rotate_tween:
					patch_rotate_tween.kill()
				patch_rotate_tween = create_tween().set_trans(Tween.TRANS_CIRC)
				patch_rotate_tween.tween_property(picked_up_patch,"position:y", 0.5,0.06)
				patch_rotate_tween.tween_property(picked_up_patch,"rotation_degrees:y", 90,0.01)	
				patch_rotate_tween.tween_property(picked_up_patch,"scale", Vector3(1.7,1.7,1.7),0.05)
				patch_rotate_tween.tween_property(picked_up_patch,"rotation_degrees:z", 45,0.1)				
									
			elif control.cast.collider.is_in_group("board"):
				var patch_rotate_tween: Tween
				if patch_rotate_tween:
					patch_rotate_tween.kill()
				patch_rotate_tween = create_tween().set_trans(Tween.TRANS_CIRC)
				patch_rotate_tween.tween_property(picked_up_patch,"rotation_degrees:z", 0,0.075)						
				patch_rotate_tween.tween_property(picked_up_patch,"scale", Vector3(1,1,1),0.02)
				patch_rotate_tween.tween_property(picked_up_patch,"position:y", 0.2,0.06)
				patch_rotate_tween.tween_property(picked_up_patch,"rotation_degrees:y", 90,0.01)	
				
var patch_spec
func _input(event: InputEvent) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLANNING:
		return
	else:
		if is_pick_up and !event.is_echo() and event.is_action_released("confirm") and control.cast.collider.is_in_group("board"):
			#if control.current_hovered_board:
			
			#print(control.board_node.board_index[control.current_hovered_board.name])
			if picked_up_patch != null:
				is_pick_up = false
				picked_up_patch.global_position = control.current_hovered_board.global_position
				picked_up_patch.global_position.y = control.current_hovered_board.global_position.y + 0.1
				
					
				util.root.data_instance.game_data.patch_data[str(control.board_node.board_index[control.current_hovered_board.name])] = patch_spec
				patch_dictionary[str(control.board_node.board_index[control.current_hovered_board.name])] = picked_up_patch
				control.current_hovered_board = null
				picked_up_patch = null
				#print(util.root.data_instance.game_data.patch_data)
				#audio_player_confirm.play()
		else:
			
			pass
			#cam.shake_node.shake(0.05)
			#audio_player_deny.play()
		
		if !event.is_echo() and event.is_action_pressed("cancel") and is_pick_up:
			if picked_up_patch != null:
				picked_up_patch.queue_free()	
			#audio_player_deny.play()
			#chess_piece.remove_move()
		

func _on_remove_patch_from_board(patch_data, vector):
	patch_dictionary[str(vector)].hide()
	util.root.data_instance.game_data.patch_data.erase(str(vector))
	print(util.root.data_instance.game_data.patch_data)
	_on_patch_picked(patch_data)

func _on_patch_picked(patch_data):
	is_pick_up = true
	var new_patch = patch_tile.instantiate()
	picked_up_patch = new_patch
	picked_up_patch.material.albedo_texture = load(patch_data.patch_image_path)
	picked_up_patch.material.albedo_color = patch_data.patch_color
	self.add_child(new_patch)	
	patch_spec = patch_data
	print("patch_selected: " + patch_data.patch_id)
