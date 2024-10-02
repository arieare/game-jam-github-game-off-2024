extends Node
class_name CommonSceneManager

func _on_change_scene(_parent, _from, _to):
	var children_size = _parent.get_child_count()
	var running_instance = _parent.get_child(children_size-1)
	if running_instance:
		running_instance.queue_free()
	if _to:
		var node_instance = _to.instantiate()
		_parent.add_child(node_instance)			

func _on_scene_ready():
	pass
