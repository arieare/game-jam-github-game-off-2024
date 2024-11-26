extends Node

signal score_added
signal move_performed
signal move_started
signal move_ended
signal game_state_change
signal board_ready
signal patch_picked
signal add_patch_to_inventory
signal remove_patch_from_inventory
signal remove_patch_from_board
signal money_amount_change
signal audio_instance_ready

signal redeem_add_money
signal redeem_theme_red
signal redeem_theme_bw
signal redeem_theme_blue
signal redeem_theme_moss
signal redeem_add_move

signal secret_letter_spawned
signal dialog_done

enum PLAYER_STATE {ON_MOVE, PLANNING}
enum MOVE_STATE {MOVE_1, MOVE_2}
enum GAME_STATE {STARTING, PLAYING, PLANNING, WINNING, LOSING, BOARD_CRUMBLE, FINALE, FINALE_2, FINALE_SECRET_CORRECT, FINALE_SECRET_WRONG, TRUE_ENDING}
var current_game_state : GAME_STATE = GAME_STATE.STARTING:
	set(value):
		current_game_state = value
		emit_signal("game_state_change",value)

signal tutorial_flag_change
var is_tutorial_flag := true :
	set(value):
		is_tutorial_flag = value
		emit_signal("tutorial_flag_change",value)

signal first_boot_change
var is_first_boot := false :
	set(value):
		is_first_boot = value
		emit_signal("first_boot_change",value)		

var audio
var stylesheet
var vfx
var instance_pool

var finale_dialog = [
	"HORSE
	“your majesty”",
	
	"QUEEN
	“why are you here?”",
	
	"QUEEN
	“...where is Sir Allen?”",
	
	"HORSE
	“pardon me your majesty, i came here on behalf of sir Allen.”",
	
	"QUEEN
	“what do you mean?”",	
	
	"HORSE
	“he wanted me to give you this letter...”",	
	
	"HORSE
	“...this is the key to our realm's victory!”",
			
	"QUEEN
	“preposterous!”",

	"QUEEN
	“suppose you tell the truth, prove it through royal SECRET-CODE or else...”",]

var finale_dialog_right = [
	"QUEEN
	“'ROYAL BLOOM'...?”",
	
	"QUEEN
	“oh no...”",
	
	"QUEEN
	“let's hear what he wanted to say...”",
	
	"** LETTER FROM THE FRONTLINE **",	
	
	"To Her Majesty, the Queen of the realm,

	The battle turns, victory is near—
	Our foes retreat, their end is clear.
	Yet I send to you, swift and free, FARIN, my steed, my loyalty.",

	"I told him this task bears the weight of war,
	so he runs with urgency only loyalty can inspire.",
	
	"Yet, it’s his safety I sought.",
	"his heart, deserves no burden of grief or pain..",
	"Let him bring you triumph, bright and true, as my journey ends where valor grew.",

	"Your knight eternal,
	Sir Allen",
	
	"QUEEN
	“...”",	

	"QUEEN
	“you foolish horse...”",		

	"QUEEN
	“he was protecting you...”",	
	
	"FARIN
	“?!... Sir Allen!”",
]

var finale_dialog_wrong = [
	"QUEEN
	“you dare messing with me?”",	

	"HORSE
	“...!”",	

	"QUEEN
	“i hereby banish you from entering my domain...”",	
]

var game_data: Dictionary = {
	"chess_piece": CharacterBody3D,
	"current_position": Vector2.ZERO,
	"current_cam": Camera3D,
	"money": 0,
	"score": 0,
	"high_score": 0,
	"multiplier": 0,
	"max_move": 8,
	"max_move_padding": 3,
	"shortest_move": 100,
	"initial_move": 0,
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
		"blocked_index" = [],
		"starting_position" = Vector2(0,0)
	},
	"patch_data": {},
	"patch_inventory": [],
	"max_patch_inventory": 3,
	"max_shop_size": 2,
	"current_level": 1,
	"secret_string": "ROYAL BLOOM UNVEIL KARDINAL TRUTH",
	"secret_string_array":[],
	"secret_string_cursor": 0
	}

var level_data: Dictionary = {
	9:  {
		"title": "the castle",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[],
		"theme_color": "white",
		"dialog": [
			"*huff*... *huff*... “it feels so far away,”",
			"“i can see it! it's the castle.”",			
			"“just... one... last... run...”",						
			],
		"shop": true,
		"spawn_secret": true,
	},			
	10:  { # Final Stage
		"title": "the letter",
		"board_size": 5,
		"starting_position": null,
		"target_position": Vector2(2,2),
		"blocked_index":[Vector2(2,3),Vector2(2,1),Vector2(1,2),Vector2(0,2), Vector2(0,0),Vector2(0,1),Vector2(0,3),Vector2(0,4)],
		"theme_color": "boss",
		"dialog": [
			"“MY QUEEN!”"
			],
		"spawn_secret": false,
	},	
	1: {
		"title": "the duty",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(1,2),
		"blocked_index":[Vector2(1,0),Vector2(2,0),Vector2(1,1), Vector2(2,1), Vector2(1,1),Vector2(2,2)],
		"theme_color": "blue",
		"dialog": [
			"*huff*... *huff*...",
			"“...must reach the castle!”"
			],
		"shop": false,
		"spawn_secret": false,
	},
	2:  {
		"title": "the stake",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(2,1),
		"blocked_index":[],
		"theme_color": "blue",
		"dialog": [
			"“the queen...”",
			"“i must deliver this! or else...”"
			],
		"shop": false,
		"spawn_secret": false,
	},	
	3:  {
		"title": "the roundabout",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(2,2),
		"blocked_index":[],
		"theme_color": "blue",
		"dialog": [
			"“...sir Allen...”",
			"“i promised him...”"
			],
		"shop": false,
		"spawn_secret": false,
	},	
	4:  {
		"title": "the memories",
		"board_size": 4,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(3,3),
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
		"theme_color": "deep_sea",
		"dialog": [
			"“what were you trying to told me?”",
			"“what was it, sir Allen?”",
			],
		"shop": false,
		"spawn_secret": true,
	},	
	5:  {
		"title": "the message",
		"board_size": 4,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(3,0),Vector2(0,3)],
		"theme_color": "deep_sea",
		"dialog": [
			"“i'm starting to remember it...”",
			"“i need to focus!”",
			],
		"shop": false,
		"spawn_secret": true,
	},	
	6:  {
		"title": "the hope",
		"board_size": 4,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(3,3),Vector2(0,1),Vector2(1,0)],
		"theme_color": "deep_sea",
		"dialog": [
			"“huh? those PATCHES might be helpful”",
			"“i could reach the castle in haste.”",			
			],
		"shop": true,
		"spawn_secret": true,
	},	
	7:  {
		"title": "the obstacle",
		"board_size": 5,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[],
		"theme_color": "lavender",
		"dialog": [
			"“this letter, is a key to our victory.”",
			"“i hope i can make it.”",			
			],
		"shop": true,
		"spawn_secret": true,
	},	
	8:  {
		"title": "the river",
		"board_size": 5,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(1,1),Vector2(2,2),Vector2(3,3),Vector2(4,4)],
		"theme_color": "lavender",
		"dialog": [
			"“this letter, is a key to our victory.”",
			"“i hope i can make it.”",			
			],
		"shop": true,
		"spawn_secret": true,
	},		

	#4:  {
		#"title": "the challenge 1",
		#"board_size": 6,
		#"starting_position": null,
		#"target_position": null,
		#"blocked_index":[Vector2(2,2),Vector2(1,1)],
		#"theme_color": "boss",
		#"shop": true
	#},			
	#5:  {
		#"title": "the challenge 2",
		#"board_size": 6,
		#"starting_position": null,
		#"target_position": null,
		#"blocked_index":[Vector2(2,2),Vector2(1,1)],
		#"theme_color": "",
		#"shop": true		
	#},	
	#6:  {
		#"title": "the secret",
		#"board_size": 8,
		#"starting_position": null,
		#"target_position": null,
		#"blocked_index":[Vector2(2,2),Vector2(1,1)],
		#"theme_color": "",
		#"shop": true
	#},					
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
			"price": 100,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_queen.png",
			"color": Color.GOLDENROD,
			},
		"log_pose":{
			"id": "log_pose",
			"name": "[wave freq=4.0 amp=0.2 connected=1]LOG POSE[/wave]",
			"description": "PUT OVER [bgcolor=CORAL]ANY TILE[/bgcolor]. REVEAL THE PATH TOWARDS THE [bgcolor=GREEN_YELLOW]GOAL[/bgcolor] IN 1ST MOVE.",
			"price": 150,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_log_pose.png",
			"color": Color.CRIMSON,
			},			
	},
	1000:{ #common
		"rook":{
			"id": "rook",
			"name": "[wave freq=4.0 amp=0.2 connected=1]ROOK[/wave]",
			"description": "PUT OVER [bgcolor=CORAL]ANY TILE[/bgcolor]. ASSUME THE MOVE SET OF [bgcolor=LIGHT_STEEL_BLUE]ROOK[/bgcolor] FOR 1 MOVE.",
			"price": 20,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_rook.png",
			"color": Color.STEEL_BLUE,
		},
		"bishop":{
			"id": "bishop",
			"name": "[wave freq=4.0 amp=0.2 connected=1]BISHOP[/wave]",
			"description": "STAND OVER THE PATCH TO ASSUME THE MOVE-SET OF [bgcolor=LIME]BISHOP[/bgcolor]. [bgcolor=CORAL]+3 POINTS[/bgcolor] PER STEP.",
			"price": 20,
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
	self.connect("secret_letter_spawned", _on_secret_letter_spawned)
	self.connect("game_state_change", _on_game_state_change)
	
	for letters in game_data.secret_string:
		if letters != " ":
			game_data.secret_string_array.append(letters)

func _on_score_added(value):
	game_data.score += value

func _on_move_performed(value):
	game_data.max_move -= value	

func _on_money_amount_change(value):
	game_data.money += value

func _on_secret_letter_spawned():
	game_data.secret_string_cursor += 1

func _on_game_state_change(state):
	match state:
		GAME_STATE.STARTING:
			game_data.current_position = Vector2.ZERO
			game_data.money = 0
			game_data.score = 0
			game_data.multiplier = 0
			game_data.max_move = 8
			game_data.max_move_padding = 3
			game_data.shortest_move = 100
			game_data.initial_move = 0
			game_data.move_step = []
			game_data.board_data = {
					"size" = 4,
					"target_position" = Vector2(0,0),
					"board_array" ={},
					"blocked_index" = [],
					"starting_position" = Vector2(0,0)
				}
			game_data.patch_data = {}
			game_data.patch_inventory = []
			game_data.max_patch_inventory = 3
			game_data.max_shop_size = 2
			game_data.current_level = 1
			#game_data.secret_string = "ROYAL BLOOM UNVEIL KARDINAL TRUTH"
			#game_data.secret_string_array =[]
			game_data.secret_string_cursor = 0
	
		GAME_STATE.TRUE_ENDING:
			if util.root.data_instance: 
				if util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.get_stream(0) == util.root.data_instance.audio.bgm_sentimental_file:
					if !util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.playing:
						util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()	
				else:
					util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
					util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.remove_stream(0)
					util.root.data_instance.audio.sfx_dictionary.bgm_player.randomizer.add_stream(0,util.root.data_instance.audio.bgm_sentimental_file, 1.0)	
					util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.play()			
		GAME_STATE.FINALE_SECRET_CORRECT:
			util.root.data_instance.audio.sfx_dictionary.bgm_player.sfx.stop()		
