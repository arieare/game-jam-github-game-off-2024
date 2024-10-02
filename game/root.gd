extends NodePlus

## List of game variable
@onready var player: RigidBody3D
@onready var cam: Node3D
@onready var cam_target = null
@onready var world: Node3D
@onready var light: DirectionalLight3D
@onready var car: RigidBody3D
@export var starting_hour: int = 12

var game_var: Dictionary = {
	"player_position": Vector3.ZERO,
	"power_up_collected": [],
	"fragment_collected": 0,
	"game_time": {
		"second" = 0,
		"minute" = 0,
		"hour" = 0,
		"day" = 0}
	}
## Skeleton
var root_node:Dictionary = {}
var common:Dictionary = {}
#@export var common: Node

## UI Nodes
@onready var ui_node: Dictionary = {
	"main_menu": preload("res://ui/main_menu/main_menu.tscn"),
	"debug_ui": preload("res://ui/debug_ui/debug_ui.tscn")}

## Game Nodes
@onready var game_node: Dictionary = {
	"prototype": preload("res://game/prototype/test_player_movement.tscn")}

#region signal callback
func _on_game_state_change(new_state:GAME_STATE):
	current_game_state = new_state

func _on_fragment_collected(value):
	game_var.fragment_collected += value
#endregion

func connect_root_signals():
	common["event_bus"].connect("change_scene", Callable(common["scene_manager"], "_on_change_scene"))
	common["event_bus"].connect("scene_ready", Callable(common["scene_manager"], "_on_scene_ready"))
	common["event_bus"].connect("fragment_collected", Callable(self, "_on_fragment_collected"))
	common["event_bus"].connect("game_state", Callable(self, "_on_game_state_change"))
	common["event_bus"].connect("car_drive_state", Callable(self, "_on_car_drive_state_change"))

## get child module of a manager node
func get_module(node:Variant, dictionary:Dictionary):
	for child_node in node.get_children():
		dictionary[child_node.name] = child_node

func _ready() -> void:
	get_module(self, root_node)
	get_module(root_node["common"], common)
	print(common)
	common["mouse_ray_cast"].init_viewport(self)
	common["input_map"].input_setting()
	common["day_time"]._set_starting_hour(starting_hour)	
	connect_root_signals()
	root_node["ui"].add_child(ui_node.main_menu.instantiate())
	root_node["game"].call_deferred("add_child",game_node.prototype.instantiate())

## Global variable
# Game State
enum GAME_STATE {START, RUNNING, PAUSE, OVER}
var prev_game_state = GAME_STATE.START
var current_game_state:GAME_STATE = GAME_STATE.START :
	set(value):
		var prev_state = current_game_state
		if current_game_state != value:
			current_game_state = value
			common.event_bus.game_state.emit(current_game_state)	

# Play State
enum PLAY_STATE {OVERWORLD, DISMANTLE}
var prev_play_state = PLAY_STATE.OVERWORLD
var current_play_state:PLAY_STATE = PLAY_STATE.OVERWORLD :
	set(value):
		var prev_state = current_play_state
		if current_play_state != value:
			current_play_state = value
			common["event_bus"].play_state.emit(current_play_state, prev_state)
