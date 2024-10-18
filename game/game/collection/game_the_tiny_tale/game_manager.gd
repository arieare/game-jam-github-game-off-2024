extends Node

## List of game variable
@onready var player: RigidBody3D
@onready var cam: compose_cam_pod_3d
@onready var cam_target = null
@onready var world: Node3D
@onready var light: DirectionalLight3D


#region state signals
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

## Global variable
# Game class_state
enum GAME_STATE {START, RUNNING, PAUSE, OVER}
var prev_game_state = GAME_STATE.START
var current_game_state:GAME_STATE = GAME_STATE.START :
	set(value):
		var prev_state = current_game_state
		if current_game_state != value:
			current_game_state = value

func _ready() -> void:
	self.connect("fragment_collected", Callable(self, "_on_fragment_collected"))
	self.connect("game_state", Callable(self, "_on_game_state_change"))


## UI Nodes
@onready var ui_node: Dictionary = {
	"carchemy_survival_main_menu": ResourceLoader.load("res://ui/collection/game_carchemy_survival/main_menu/main_menu.tscn"),
	"carchemy_survival_arcade_ui": ResourceLoader.load("res://ui/collection/game_carchemy_survival/main_menu/main_menu.tscn")
	}
