extends Node3D

@export var control: Node3D

var is_pick_up: bool = false
var picked_up_patch
@export var patch_tile:PackedScene



func _ready() -> void:
	util.root.data_instance.connect("patch_picked", _on_patch_picked)

var elapsed:=0.0
func _process(delta: float) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLANNING:
		return
	else:
		if is_pick_up and control.cast and !control.cast.collider.is_in_group("patch") and picked_up_patch != null:
			
			picked_up_patch.global_position = control.cast.position
			
			if !control.cast.collider.is_in_group("board"):
				elapsed = 0.0
				picked_up_patch.rotation_degrees.x = lerp_angle(45.0,0,elapsed)
				picked_up_patch.position.y = lerpf(0,1,elapsed)
				picked_up_patch.scale.x = lerpf(1.75,1,elapsed)
				picked_up_patch.scale.y = lerpf(1.75,1,elapsed)
				picked_up_patch.scale.z = lerpf(1.75,1,elapsed)
				elapsed += delta
			
			elif control.cast.collider.is_in_group("board"):
				elapsed = 0.0
				picked_up_patch.rotation_degrees.x = lerp_angle(0,45,elapsed)
				picked_up_patch.position.y = lerpf(0.3,2.0,elapsed)
				picked_up_patch.scale.x = lerpf(1,1.75,elapsed)
				picked_up_patch.scale.y = lerpf(1,1.75,elapsed)
				picked_up_patch.scale.z = lerpf(1,1.75,elapsed)			
				elapsed += delta		
				
var patch_spec
func _input(event: InputEvent) -> void:
	if util.root.data_instance.current_game_state != util.root.data_instance.GAME_STATE.PLANNING:
		return
	else:
		if is_pick_up and !event.is_echo() and event.is_action_pressed("confirm") and control.current_hovered_board:
			#if control.current_hovered_board:
			print(control.board_node.board_index[control.current_hovered_board.name])
			if picked_up_patch != null:
				is_pick_up = false
				picked_up_patch.global_position = control.current_hovered_board.global_position
				picked_up_patch.global_position.y = control.current_hovered_board.global_position.y + 0.1
				util.root.data_instance.game_data.patch_data[str(control.board_node.board_index[control.current_hovered_board.name])] = patch_spec
				print(util.root.data_instance.game_data.patch_data)
				#audio_player_confirm.play()
		else:
			pass
			#cam.shake_node.shake(0.05)
			#audio_player_deny.play()
		
		if !event.is_echo() and event.is_action_pressed("cancel"):
			if picked_up_patch != null:
				picked_up_patch.queue_free()	
			#audio_player_deny.play()
			#chess_piece.remove_move()
		



func _on_patch_picked(patch_data):
	is_pick_up = true
	var new_patch = patch_tile.instantiate()
	picked_up_patch = new_patch
	self.add_child(new_patch)	
	patch_spec = patch_data
	print("patch_selected: " + patch_data)
