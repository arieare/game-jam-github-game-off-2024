extends Node

signal score_added
signal move_performed
signal move_added
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
	“...where is ser Allen?”",
	
	"HORSE
	“pardon me your majesty, i came here on behalf of ser Allen.”",
	
	"QUEEN
	“what do you mean?”",	
	
	"HORSE
	“he wanted me to give you this letter... this is the key to our realm's victory!”",
			
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
	“let's hear what he has to say...”",
	
	"** LETTER FROM THE FRONTLINE **",	
	
	"To Her Majesty, the Queen of the realm,

	The battle turns, victory is near—
	Our foes retreat, their end is clear.
	Yet I send to you, swift and free,
	FARIN, my loyal steed.",

	"I told him this task bears the weight of war,
	so he runs with urgency only loyalty can inspire.",
	
	"Yet, it’s his safety I sought.",
	"his heart, deserves no burden of grief or pain..",
	"Let him bring you triumph, bright and true, as my journey ends where valor grew.",

	"Your knight eternal,
	ser Allen",
	
	"QUEEN
	“...”",	

	"QUEEN
	“you foolish horse...”",		

	"QUEEN
	“he was protecting you...”",	
	
	"FARIN
	“?!... ser Allen!”",
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
	"max_shop_size": 3,
	"current_level": 1,
	"secret_string": "ROYAL BLOOM UNVEIL KARDINAL TRUTH",
	"secret_string_array":[],
	"secret_string_cursor": 0
	}

var level_data: Dictionary = {

	1: {
		"title": "the duty",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(1,2),
		"blocked_index":[Vector2(1,0),Vector2(2,0),Vector2(1,1), Vector2(2,1), Vector2(1,1),Vector2(2,2)],
		"theme_color": "high_noon",
		"dialog": [
			"*huff*... *huff*...must reach the castle!”"
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
		"theme_color": "high_noon",
		"dialog": [
			"“'find the queen'... that's what ser Allen says”",
			"“i must deliver this! at all cost...”"
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
		"theme_color": "high_noon",
		"dialog": [
			"“this letter, is the key to our victory... i hope i can make it in time!”",					
			],
		"shop": false,
		"spawn_secret": false,
	},	
	4:  {
		"title": "the hope",
		"board_size": 4,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(3,3),
		"blocked_index":[Vector2(2,2),Vector2(1,1)],	
		"theme_color": "moss",
		"dialog": [
			"“huh? those PATCHES might be useful”",
			"“i could reach THE CASTLE with haste.”",			
			],
		"shop": true,
		"spawn_secret": false,
	},	
	5:  {
		"title": "the memories",
		"board_size": 4,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(3,3),Vector2(0,1),Vector2(1,0)],
		"theme_color": "moss",
		"dialog": [
			"“you say, 'one more thing, REMEMBER this KEYWORDS...'", 
			"“oh no... what was the KEYWORDS, ser Allen?”",
			],
		"shop": true,
		"spawn_secret": true,
	},	
	6:  {
		"title": "the message",
		"board_size": 4,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(3,0),Vector2(0,3)],
		"theme_color": "moss",
		"dialog": [
			"R...O...",
			"“i'm starting to remember it... i need to focus!”",
			],
		"shop": true,
		"spawn_secret": true,
	},	
	7:  {
		"title": "the cliff",
		"board_size": 5,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,1),Vector2(0,3), Vector2(4,1),Vector2(4,3)],
		"theme_color": "sunset",
		#"dialog": [
			#"“...ser Allen... i promised him...”",
			#"“'this letter, is a key to our victory.'”",			
			#],
		"shop": true,
		"spawn_secret": true,
	},	
	8:  {
		"title": "the river",
		"board_size": 5,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(1,1),Vector2(2,2),Vector2(3,3),Vector2(4,4)],
		"theme_color": "sunset",
		#"dialog": [
			#"“this letter, is a key to our victory.”",
			#"“i hope i can make it.”",			
			#],
		"shop": true,
		"spawn_secret": true,
	},
	9:  {
		"title": "the valley",
		"board_size": 5,
		"starting_position": Vector2(3,4),
		"target_position": Vector2(1,1),
		"blocked_index":[Vector2(2,1),Vector2(1,2),Vector2(2,3),Vector2(3,2),Vector2(0,0),Vector2(4,0), Vector2(0,4),Vector2(4,4),Vector2(2,2)],
		"theme_color": "sunset",
		"dialog": [
			"“...i'm tired...”",
			],
		"shop": true,
		"spawn_secret": true,
		"prop": {
			"sword": [Vector2(2,2)],
			},
	},				
	10:  {
		"title": "the night",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,2),Vector2(0,3),Vector2(2,0),Vector2(3,0),Vector2(5,2),Vector2(5,3),Vector2(2,5),Vector2(3,5)],
		"theme_color": "deep_sea",
		#"dialog": [
			#"“...i'm tired...”",
			#],
		"shop": true,
		"spawn_secret": true,
	},	
	11:  { #11
		"title": "the crossroad",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1),
		Vector2(0,4),Vector2(0,5),Vector2(1,4),Vector2(1,5),
		Vector2(4,0),Vector2(4,1),Vector2(5,0),Vector2(5,1),
		Vector2(4,4),Vector2(4,5),Vector2(5,4),Vector2(5,5)
		],
		"theme_color": "deep_sea",
		#"dialog": [
			#"“...i'm tired...”",
			#],
		"shop": true,
		"spawn_secret": true,
	},		
	12:  { #12
		"title": "the camp",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(1,1),Vector2(1,4),Vector2(4,1),Vector2(4,4)],
		"theme_color": "deep_sea",
		"dialog": [
			"“i can do it. i know ser Allen will be proud of me!”",
			],
		"shop": true,
		"spawn_secret": true,
	},	
	13:  { #13
		"title": "the bridge",
		"board_size": 7,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,3),Vector2(1,3),Vector2(2,3),Vector2(4,3),Vector2(5,3),Vector2(6,3)
		],
		"theme_color": "lavender",
		#"dialog": [
			#"“...can i do it? i know ser Allen will be proud of me!”",
			#],
		"shop": true,
		"spawn_secret": true,
	},	
	14:  { #14
		"title": "the depth",
		"board_size": 7,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(1,0),Vector2(0,1),
		Vector2(0,4),Vector2(1,3),Vector2(2,2),
		Vector2(6,2),Vector2(5,3),Vector2(4,4),
		Vector2(6,5),Vector2(5,6),
		],
		"theme_color": "lavender",
		#"dialog": [
			#"“...can i do it? i know ser Allen will be proud of me!”",
			#],
		"shop": true,
		"spawn_secret": true,
	},		
	15:  { #15
		"title": "the abyss",
		"board_size": 7,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,3),Vector2(0,4),Vector2(0,5),Vector2(0,6),
		Vector2(1,3),Vector2(1,4),Vector2(1,5),Vector2(1,6),
		Vector2(2,3),Vector2(2,4),Vector2(2,5),Vector2(2,6),
		Vector2(3,3),Vector2(3,4),Vector2(3,5),Vector2(3,6),
		Vector2(0,0),Vector2(0,1),Vector2(0,2),
		Vector2(1,1),Vector2(1,2),
		Vector2(2,2),
		Vector2(4,4),Vector2(4,5),Vector2(4,6),
		Vector2(5,5),Vector2(5,6),
		Vector2(6,6),		
		],
		"theme_color": "lavender",
		"dialog": [
			"“...can i do it?...”",
			],
		"shop": true,
		"spawn_secret": true,
	},
	16:  { #16
		"title": "the mark",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(1,1),Vector2(2,2),Vector2(3,3),Vector2(4,4),Vector2(5,5),Vector2(6,6),
		Vector2(1,6),Vector2(2,5),Vector2(3,4),
		Vector2(4,3),Vector2(5,2),Vector2(6,1)
		],
		"theme_color": "boss",
		#"dialog": [
			#"“...can i do it? i know ser Allen will be proud of me!”",
			#],
		"shop": true,
		"spawn_secret": true,
	},
	17:  { #17
		"title": "the hill",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(2,0),Vector2(1,1),Vector2(0,2),
		Vector2(0,7),Vector2(1,7),Vector2(0,6),Vector2(2,7),Vector2(1,6),Vector2(0,5),
		Vector2(7,0),Vector2(6,0),Vector2(7,1),Vector2(5,0),Vector2(6,1),Vector2(7,2),
		Vector2(7,7),Vector2(6,7),Vector2(7,6),Vector2(5,7),Vector2(6,6),Vector2(7,5),
		Vector2(2,3),Vector2(2,4),Vector2(5,3),Vector2(5,4)
		],
		"theme_color": "boss",
		#"dialog": [
			#"“...can i do it? i know ser Allen will be proud of me!”",
			#],
		"shop": true,
		"spawn_secret": true,
	},			
	18:  { #18
		"title": "the castle",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,5),Vector2(1,5),Vector2(2,5),Vector2(3,5),Vector2(4,5),Vector2(5,5),Vector2(7,2),Vector2(6,2),Vector2(5,2),Vector2(4,2),Vector2(3,2),Vector2(2,2)],
		"theme_color": "boss",
		"dialog": [
			"*huff*... *huff*... “it feels so far away,”",
			"“i can see it! it's the castle.”",
			],
		"shop": true,
		"spawn_secret": true,
	},	
	19:  { #19
		"title": "the hall",
		"board_size": 5,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0),Vector2(0,4),Vector2(1,4),Vector2(2,4),Vector2(3,4),Vector2(4,4),Vector2(0,1),Vector2(4,3)],
		"theme_color": "boss",
		"dialog": [	
			"“just... one... last... run...”",						
			],
		"shop": true,
		"spawn_secret": true,
	},				
	20:  { # Final Stage 20
		"title": "the letter",
		"board_size": 5,
		"starting_position": null,
		"target_position": Vector2(2,2),
		"blocked_index":[Vector2(2,3),Vector2(2,1),Vector2(1,2),Vector2(0,2), Vector2(0,0),Vector2(0,1),Vector2(0,3),Vector2(0,4)],
		"theme_color": "snow",
		"dialog": [
			"“MY QUEEN!”"
			],
		"shop": false,
		"spawn_secret": false,
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
			"description": "STAND OVER THE PATCH TO ASSUME THE MOVE-SET OF [bgcolor=GOLDENROD]QUEEN[/bgcolor]. [bgcolor=CORAL]+9 POINTS[/bgcolor] PER STEP.",
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
			"description": "STAND OVER THE PATCH TO ASSUME THE MOVE-SET OF [bgcolor=STEEL_BLUE]BISHOP[/bgcolor]. [bgcolor=CORAL]+5 POINTS[/bgcolor] PER STEP.",
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
		"dir_up_1":{
			"id": "dir_up_1",
			"name": "[wave freq=4.0 amp=0.2 connected=1]MOVE ONE UP[/wave]",
			"description": "STAND OVER THE PATCH TO [bgcolor=CORAL]MOVE ONE UP[/bgcolor].",
			"price": 10,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_dir_up_1.png",
			"color": Color.CORAL,
		},		
		"dir_down_1":{
			"id": "dir_down_1",
			"name": "[wave freq=4.0 amp=0.2 connected=1]MOVE ONE DOWN[/wave]",
			"description": "STAND OVER THE PATCH TO [bgcolor=CORAL]MOVE ONE DOWN[/bgcolor].",
			"price": 10,
			"image": "res://collection/rogue_knight/content/sprite/patch/patch_dir_down_1.png",
			"color": Color.CORAL,
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
			game_data.max_shop_size = 3
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
