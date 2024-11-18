extends Node

signal score_added
signal move_performed
signal move_started
signal game_state_change
signal board_ready
signal patch_picked
signal add_patch_to_inventory
signal remove_patch_from_inventory
signal money_amount_change
signal audio_instance_ready

enum PLAYER_STATE {ON_MOVE, PLANNING}
enum MOVE_STATE {MOVE_1, MOVE_2}
enum GAME_STATE {STARTING, PLAYING, PLANNING, WINNING, LOSING, BOARD_CRUMBLE}
var current_game_state : GAME_STATE = GAME_STATE.STARTING:
	set(value):
		current_game_state = value
		emit_signal("game_state_change",value)

var audio
var stylesheet
var vfx
var instance_pool

var game_data: Dictionary = {
	"chess_piece": CharacterBody3D,
	"current_position": Vector2.ZERO,
	"current_cam": Camera3D,
	"money": 30,
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
		"size" = 4,
		"target_position" = Vector2(0,0),
		"board_array" ={},
		"blocked_index" = []
	},
	"patch_data": {},
	"patch_inventory": [],
	"max_patch_inventory": 3,
	"max_shop_size": 2,
	"current_level": 1,
	"secret_string": "FINISHED"
	}

var level_data: Dictionary = {
	1: {
		"title": "the beginning",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(2,1),
		"blocked_index":[],
		"theme_color": ""
	},
	2:  {
		"title": "the obstacle",
		"board_size": 4,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(3,3),
		"blocked_index":[],
		"theme_color": ""
	},
	3:  {
		"title": "the challenge",
		"board_size": 4,
		"starting_position": Vector2(0,0),
		"target_position":Vector2(3,3),
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": "boss"
	},	
	4:  {
		"title": "the crossroad",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": ""
	},	
	5:  {
		"title": "the challenge 1",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": ""
	},			
	6:  {
		"title": "the challenge 2",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": ""
	},	
	7:  {
		"title": "the secret",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": ""
	},					
}

## rarity
# 1000 common
# 500 rare
# 250 epic
# 100 legendary
var patch_dictionary = {
	250:{ #epic
		"queen":{
			"id": "queen",
			"name": "[wave freq=4.0 amp=0.2 connected=1]QUEEN[/wave]",
			"description": "PUT OVER [bgcolor=CORAL]ANY TILE[/bgcolor]. ASSUME THE MOVE SET OF [bgcolor=GOLD]QUEEN[/bgcolor] FOR 1 MOVE.",
			"price": 10,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_queen.png",
			"color": Color.GOLDENROD,
			},
		"log_pose":{
			"id": "log_pose",
			"name": "[wave freq=4.0 amp=0.2 connected=1]LOG POSE[/wave]",
			"description": "PUT OVER [bgcolor=CORAL]ANY TILE[/bgcolor]. REVEAL THE PATH TOWARDS THE [bgcolor=GREEN_YELLOW]GOAL[/bgcolor] IN 1ST MOVE.",
			"price": 10,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_log_pose.png",
			"color": Color.CRIMSON,
			},			
	},
	1000:{ #common
		"rook":{
			"id": "rook",
			"name": "[wave freq=4.0 amp=0.2 connected=1]ROOK[/wave]",
			"description": "PUT OVER [bgcolor=CORAL]ANY TILE[/bgcolor]. ASSUME THE MOVE SET OF [bgcolor=LIGHT_STEEL_BLUE]ROOK[/bgcolor] FOR 1 MOVE.",
			"price": 8,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_rook.png",
			"color": Color.STEEL_BLUE,
		},
		"bishop":{
			"id": "bishop",
			"name": "[wave freq=4.0 amp=0.2 connected=1]BISHOP[/wave]",
			"description": "STAND OVER THE PATCH TO ASSUME THE MOVE-SET OF [bgcolor=LIME]BISHOP[/bgcolor]. [bgcolor=CORAL]+3 POINTS[/bgcolor] PER STEP.",
			"price": 8,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_bishop.png",
			"color": Color.LIME,
		},		
	},	
}

var player_move_set := []

func _ready() -> void:
		
	self.connect("score_added", _on_score_added)
	self.connect("move_performed", _on_move_performed)
	self.connect("money_amount_change", _on_money_amount_change)
	#audio = $audio

func _on_score_added(value):
	game_data.score += value

func _on_move_performed(value):
	game_data.max_move -= value	

func _on_money_amount_change(value):
	game_data.money += value
