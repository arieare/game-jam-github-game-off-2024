extends Node3D

@export var square_overlay: PackedScene
@export var square_overlay_target: PackedScene
var overlay_array := []
@export var board_node: Node3D

func spawn_legal_move_hint(square_index, legal_move_array: Array):
	clear_legal_move_hint()
	for square in legal_move_array:
		#if board_node.board_array.has(square.x):
		if int(square.x) < util.root.data_instance.game_data.board_data.size and int(square.y) < util.root.data_instance.game_data.board_data.size: 
			var overlay = square_overlay.instantiate()
			overlay.position = board_node.board_array[int(square.x)][int(square.y)].position
			overlay.position.y = 0.15
			self.get_parent().add_child.call_deferred(overlay)
			overlay_array.append(overlay)	

func clear_legal_move_hint():
	for nodes in overlay_array:
		nodes.queue_free()
	overlay_array.clear()

func spawn_target_move_hint(square_index):
	#clear_legal_move_hint()
	var overlay = square_overlay_target.instantiate()
	overlay.position = square_index.position
	overlay.position.y = 0.15
	self.get_parent().add_child.call_deferred(overlay)
	overlay_array.append(overlay)	
