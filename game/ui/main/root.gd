extends NodePlus
class_name class_root_game

## List of game variable
@onready var player: RigidBody3D
@onready var cam: compose_cam_pod_3d
@onready var cam_target = null
@onready var world: Node3D
@onready var light: DirectionalLight3D

#region app signals
signal change_scene
signal scene_ready
#endregion

#region state signals
signal game_state(current_state, previous_state)
signal play_state(current_state, previous_state)
#endregion

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
var node_list:Dictionary = {}

## UI Nodes
@onready var ui_node: Dictionary = {
	"root_main_menu": ResourceLoader.load("res://ui/main/root_main_menu/root_main_menu.tscn"),
	"game_selection_menu": ResourceLoader.load("res://ui/main/game_selection_menu/game_selection_menu.tscn"),
	"the_tiny_tale_main_menu": ResourceLoader.load("res://ui/collection/game_the_tiny_tale/main_menu/main_menu.tscn"),	
	"carchemy_survival_main_menu": ResourceLoader.load("res://ui/collection/game_carchemy_survival/main_menu/main_menu.tscn") 
	}

## Game Nodes
@onready var game_node: Dictionary = {
	"the_tiny_tale": ResourceLoader.load("res://game/collection/game_the_tiny_tale/test_player_movement.tscn"),
	"carchemy_survival_main_menu": ResourceLoader.load("res://game/collection/game_the_tiny_tale/test_player_movement.tscn")
}

#region signal callback
func _on_game_state_change(new_state:GAME_STATE):
	current_game_state = new_state
#endregion

func connect_root_signals():
	self.connect("change_scene", Callable(global.scene_manager, "_on_change_scene"))
	self.connect("scene_ready", Callable(global.scene_manager, "_on_scene_ready"))
	#self.connect("fragment_collected", Callable(self, "_on_fragment_collected"))
	self.connect("game_state", Callable(self, "_on_game_state_change"))

## get child module of a manager node
func get_module(node:Variant, dictionary:Dictionary):
	for child_node in node.get_children():
		dictionary[child_node.name] = child_node

func _ready() -> void:
	get_module(self, node_list)
	connect_root_signals()
	node_list["ui"].add_child(ui_node.root_main_menu.instantiate())

## Global variable
# Game class_state
enum GAME_STATE {START, RUNNING, PAUSE, OVER}
var prev_game_state = GAME_STATE.START
var current_game_state:GAME_STATE = GAME_STATE.START :
	set(value):
		var prev_state = current_game_state
		if current_game_state != value:
			current_game_state = value
			self.game_state.emit(current_game_state)	
