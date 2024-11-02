extends Node3D

@export var square_overlay: PackedScene
var overlay_array := []
@export var board_node: Node3D

func spawn_legal_move_hint(square_index, legal_move_array: Array):
	clear_legal_move_hint()
	for square in legal_move_array:
		var overlay = square_overlay.instantiate()
		overlay.position = board_node.board_array[int(square.x)][int(square.y)].position
		overlay.position.y = 0.1
		self.get_parent().add_child.call_deferred(overlay)
		overlay.top_level = true
		overlay_array.append(overlay)	

func clear_legal_move_hint():
	for nodes in overlay_array:
		nodes.queue_free()
	overlay_array.clear()
