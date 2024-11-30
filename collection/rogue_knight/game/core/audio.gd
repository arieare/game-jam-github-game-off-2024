extends Node

@export var bgm_main_menu_file: AudioStream
@export var bgm_in_game_1: AudioStream
@export var bgm_in_game_2: AudioStream
@export var bgm_game_over_file: AudioStream
@export var bgm_sentimental_file: AudioStream
@export var sfx_caching_file: AudioStream
@export var sfx_step_on_board_file: AudioStream
@export var sfx_board_initialized_file: AudioStream
@export var sfx_coin_1_file: AudioStream
@export var sfx_coin_2_file: AudioStream
@export var sfx_coin_3_file: AudioStream
@export var sfx_tile_hover_file: AudioStream
@export var sfx_tile_select_deny_file: AudioStream
@export var sfx_tile_select_confirm_file: AudioStream
@export var sfx_tile_select_move_file: AudioStream
@export var sfx_shop_item_added_file: AudioStream
@export var sfx_point_spawned_file: AudioStream
@export var sfx_patch_selected_file: AudioStream
@export var sfx_patch_put_down_file: AudioStream
@export var sfx_patch_burn_file: AudioStream
@export var sfx_typing_file: AudioStream
@export var sfx_redeem_confirm_file: AudioStream
@export var sfx_redeem_deny_file: AudioStream
@export var sfx_chat_bubble_file: AudioStream
@export var sfx_reach_goal_file: AudioStream

@onready var sfx_dictionary = {
	"bgm_player": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": bgm_main_menu_file,
		"random_var": 1.0,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"bgm",
	},	
	"bgm_intro": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": bgm_main_menu_file,
		"random_var": 1.0,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"bgm",
	},
	"bgm_in_game_1": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": bgm_in_game_1,
		"random_var": 1.0,
		"base_pitch": 1.0,
		"base_volume": 0.5,
		"bus": &"bgm",
	},	
	"bgm_game_over": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": bgm_game_over_file,
		"random_var": 1.0,
		"base_pitch": 1.0,
		"base_volume": 0.5,
		"bus": &"bgm",
	},		
	"caching": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_caching_file,
		"random_var": 1.0,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"step_on_board": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_step_on_board_file,
		"random_var": 1.05,
		"base_pitch": 2.0,
		"base_volume": 2.0,
		"bus": &"sfx",
	},
	"board_initialized": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_board_initialized_file,
		"random_var": 1.1,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"coin_1": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_coin_1_file,
		"random_var": 1.0,
		"base_pitch": 2.0,
		"base_volume": 7.0,
		"bus": &"sfx",
	},
	"coin_2": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_coin_2_file,
		"random_var": 1.0,
		"base_pitch": 2.0,
		"base_volume": 7.0,
		"bus": &"sfx",
	},
	"coin_3": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_coin_3_file,
		"random_var": 1.0,
		"base_pitch": 2.0,
		"base_volume": 7.0,
		"bus": &"sfx",
	},
	"tile_hover": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_tile_hover_file,
		"random_var": 1.2,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"tile_select_deny": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_tile_select_deny_file,
		"random_var": 1.1,
		"base_pitch": 1.0,
		"base_volume": -5.0,
		"bus": &"sfx",
	},
	"tile_select_confirm": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_tile_select_confirm_file,
		"random_var": 1.01,
		"base_pitch": 3.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"tile_select_move": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_tile_select_move_file,
		"random_var": 1.01,
		"base_pitch": 1.0,
		"base_volume": 7.0,
		"bus": &"sfx",
	},
	"shop_item_added": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_shop_item_added_file,
		"random_var": 1.25,
		"base_pitch": 0.8,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"point_spawned": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_point_spawned_file,
		"random_var": 1.1,
		"base_pitch": 2.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},
	"patch_selected": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_patch_selected_file,
		"random_var": 1.1,
		"base_pitch": 2.0,
		"base_volume": 2.0,
		"bus": &"sfx",
	},
	"patch_put_down": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_patch_put_down_file,
		"random_var": 1.1,
		"base_pitch": 3.0,
		"base_volume": 2.0,
		"bus": &"sfx",
	},	
	"patch_burn": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_patch_burn_file,
		"random_var": 1.1,
		"base_pitch": -2.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},	
	"typing": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_typing_file,
		"random_var": 1.2,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},	
	"redeem_confirm": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_redeem_confirm_file,
		"random_var": 1.2,
		"base_pitch": 2.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},	
	"redeem_deny": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_redeem_deny_file,
		"random_var": 1.2,
		"base_pitch": 1.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	},	
	"chat_bubble": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_chat_bubble_file,
		"random_var": 6.0,
		"base_pitch": 1.0,
		"base_volume": 0.3,
		"bus": &"sfx",
	},	
	"reach_goal": {
		"sfx": AudioStreamPlayer.new(),
		"randomizer": AudioStreamRandomizer.new(),
		"file": sfx_reach_goal_file,
		"random_var": 1.0,
		"base_pitch": 3.0,
		"base_volume": 1.0,
		"bus": &"sfx",
	}				
					
}
func init_audio():
	for sfx in sfx_dictionary:
		sfx_dictionary[sfx]["sfx"].max_polyphony = 128
		sfx_dictionary[sfx]["sfx"].pitch_scale = sfx_dictionary[sfx]["base_pitch"]
		sfx_dictionary[sfx]["sfx"].volume_db = linear_to_db(float(sfx_dictionary[sfx]["base_volume"]))
		sfx_dictionary[sfx]["sfx"].stream = sfx_dictionary[sfx]["randomizer"]
		sfx_dictionary[sfx]["sfx"].bus = sfx_dictionary[sfx]["bus"]
		sfx_dictionary[sfx]["randomizer"].add_stream(0,sfx_dictionary[sfx]["file"], 1.0)
		sfx_dictionary[sfx]["randomizer"].random_pitch = sfx_dictionary[sfx]["random_var"]
		self.add_child(sfx_dictionary[sfx]["sfx"])

func _ready():
	init_audio()
	self.get_parent().audio = self #dependency injection
	#how to use -> util.root.data_instance.audio.sfx_dictionary.coin_3.sfx.play()
