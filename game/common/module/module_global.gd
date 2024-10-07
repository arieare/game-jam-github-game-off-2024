extends Node

@onready var bob_sine: module_bob_sine = module_bob_sine.new()
@onready var pid_controller: module_pid_controller = module_pid_controller.new()
@onready var input_map: module_input_map = module_input_map.new()
@onready var mouse_raycast: module_mouse_ray_cast = module_mouse_ray_cast.new()
@onready var look_at_target: module_look_at_target = module_look_at_target.new()
@onready var aim_cursor: module_aim_cursor = module_aim_cursor.new()
@onready var interaction_manager: module_interaction_manager = module_interaction_manager.new()
@onready var hit_stop: module_hit_stop = module_hit_stop.new()
@onready var scene_manager: module_scene_manager = module_scene_manager.new()
