extends Button
class_name NodeButtonPlus

## get direct access to root node
@onready var root: class_root_game

func _ready() -> void:
	for child in get_tree().get_root().get_children():
		if child is class_root_game: root = child
