extends Node2D
var crystal_scene = preload("res://content/collection/game_carchemy_survival/scene/crystal.tscn")
@onready var root_node = get_tree().get_root().get_child(0)
var is_crystal_message_displayed: bool = false
@export var stage_node: Node2D

func _ready() -> void:
	root_node.connect("crystal_hit", on_hit)
	await get_tree().create_timer(2.0).timeout
	if !is_crystal_message_displayed:
		stage_node.emit_signal("arcade_state", "stay in the middle.")
		is_crystal_message_displayed = true
	var new_crystal = crystal_scene.instantiate()
	new_crystal.crystal = new_crystal.crystal_type.values().pick_random()
	self.add_child(new_crystal)
	new_crystal.global_position.x = randi_range(30, 700)
	new_crystal.global_position.y = randi_range(70, 300)	


func on_hit(type):
	self.get_child(0).queue_free()
	await get_tree().create_timer(1.0).timeout
	var new_crystal = crystal_scene.instantiate()
	new_crystal.crystal = new_crystal.crystal_type.values().pick_random()
	self.add_child(new_crystal)
	new_crystal.global_position.x = randi_range(10, 700)
	new_crystal.global_position.y = randi_range(70, 400)
	
