class_name util_get_child_node

## get child module of a manager node
func get_member(node:Variant, dictionary:Dictionary):
	for child_node in node.get_children():
		dictionary[child_node.name] = child_node
