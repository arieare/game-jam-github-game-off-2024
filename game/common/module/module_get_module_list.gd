extends Node
class_name module_get_module_list

## get child module of a manager node
func get_module(node:Variant, dictionary:Dictionary):
	for child_node in node.get_children():
		dictionary[child_node.name] = child_node
