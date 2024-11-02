extends Node

signal score_added
signal move_performed
signal game_state_change
signal board_ready
signal patch_picked

enum PLAYER_STATE {ON_MOVE, PLANNING}
enum MOVE_STATE {MOVE_1, MOVE_2}
enum GAME_STATE {STARTING, PLAYING, PLANNING, WINNING, LOSING}
var current_game_state : GAME_STATE = GAME_STATE.STARTING:
	set(value):
		current_game_state = value
		emit_signal("game_state_change",value)

var game_data: Dictionary = {
	"chess_piece": CharacterBody3D,
	"current_position": Vector2.ZERO,
	"money": 0,
	"score": 0,
	"multiplier": 0,
	"max_move": 8,
	"move_step": [],
	"game_time": {
		"second" = 0,
		"minute" = 0,
		"hour" = 0,
		"day" = 0},
	"board_data": {
		"size" = 8
	},
	"patch_data": {
	}	
	}

#var board_size := 8
var player_move_set := []

func _ready() -> void:
	self.connect("score_added", _on_score_added)
	self.connect("move_performed", _on_move_performed)

func _on_score_added(value):
	game_data.score += value

func _on_move_performed(value):
	game_data.max_move -= value	
