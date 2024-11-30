extends Node

@onready var bob_sine := util_bob_sine.new() #calculate()
@onready var pid := util_pid_controller.new()

@onready var mouse := util_mouse_ray_cast.new()
@onready var look_at_target := util_look_at_target.new()

#@onready var input_map: module_input_map = module_input_map.new()
#@onready var interaction_manager: module_interaction_manager = module_interaction_manager.new()

@onready var hit_stop := util_hit_stop.new()
@onready var slow_mo := util_slow_mo.new()

@onready var scene_manager := util_scene_manager.new()
@onready var child_node := util_get_child_node.new()
@onready var save_load := util_save_load.new()

@onready var curve_3d := draw_curve.new()

signal root_ready
signal data_ready
signal data_instance_ready
var root: Variant
func _ready() -> void:
	self.connect("root_ready",_on_root_ready)
func _on_root_ready(node:Variant):
	root = node
