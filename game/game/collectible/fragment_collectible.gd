@icon("res://content/icon/node_icon_collectible.svg")
extends Node3D
class_name Collectible

@onready var root = get_tree().get_root().get_child(0)
@export var interaction:InteractionAreaModule

func _ready() -> void:
	interaction.interact = Callable(self, "_interact_pick_fragment")

func _interact_pick_fragment():
	var move_toward_position = root.player.global_position
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "global_position", move_toward_position, 0.2)
	await tween.finished
	self.queue_free()
	root.common.event_bus.emit_signal("fragment_collected", 1)
