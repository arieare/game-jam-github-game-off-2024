extends Area2D


@onready var root_node = get_tree().get_root().get_child(0)

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		root_node.emit_signal("times_up")
