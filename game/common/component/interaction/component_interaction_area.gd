extends Area3D
class_name component_interaction_area

## List of node
@onready var root = get_tree().get_root().get_child(0)
@export var interaction_name: String = "interact"
@export var interaction_manager: module_interaction_manager

@export var collision:CollisionShape3D
@export var collision_radius: float = 2.0

func _ready() -> void:
	collision.shape.radius = collision_radius

var interact: Callable = func():
	pass



func _on_body_entered(body: Node3D) -> void:
	interaction_manager.register_interaction_area(self)

func _on_body_exited(body: Node3D) -> void:
	interaction_manager.unregister_interaction_area(self)
