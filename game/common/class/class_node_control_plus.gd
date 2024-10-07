extends Control
class_name NodeControlPlus

## get direct access to root node
@onready var root: class_root_game

func _enter_tree() -> void:
	print(get_tree().get_root().get_children())
	for child in get_tree().get_root().get_children():
		if child is class_root_game: 
			root = child	
	
