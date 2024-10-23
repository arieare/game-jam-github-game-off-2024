extends Node

signal game_state
signal fragment_collected
enum GAME_STATE {START, RUNNING, PAUSE, OVER}
var prev_game_state = GAME_STATE.START
var current_game_state:GAME_STATE = GAME_STATE.START :
	set(value):
		var prev_state = current_game_state
		if current_game_state != value:
			current_game_state = value
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

@onready var player: RigidBody3D
@onready var cam: compose_cam_pod_3d
@onready var cam_target = null
@onready var world: Node3D
@onready var light: DirectionalLight3D

func _ready() -> void:
	print("game variable ready")
	self.connect("fragment_collected", Callable(self, "_on_fragment_collected"))
	self.connect("game_state", Callable(self, "_on_game_state_change"))

func _on_fragment_collected():
	game_var.fragment_collected += 1

'''
01. @tool
02. class_name (PascalCase)
03. extends
04. # docstring

05. signals (snake_case)
06. enums (PascalCase, members are CONSTANT_CASE)
07. constants (CONSTANT_CASE)
08. @export variables (snake_case)
09. public variables (non-underscore-prefixed snake_case)
10. private variables (underscore-prefixed _snake_case)
11. @onready variables (snake_case)

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods (underscore-prefixed _snake_case)
16. public methods (non-underscore-prefixed snake_case)
17. private methods (underscore-prefixed _snake_case)
18. subclasses (PascalCase)
'''
