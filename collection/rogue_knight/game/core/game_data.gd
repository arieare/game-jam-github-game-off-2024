extends Node

signal score_added
signal move_performed
signal game_state_change
signal board_ready
signal patch_picked
signal add_patch_to_inventory
signal remove_patch_from_inventory
signal money_amount_change

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
	}

var level_data: Dictionary = {
	1: {
		"title": "the beginning",
		"board_size": 3,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(1,2),
		"blocked_index":[]
	},
	2:  {
		"title": "the obstacle",
		"board_size": 4,
		"starting_position": Vector2(0,0),
		"target_position": Vector2(2,1),
		"blocked_index":[Vector2(2,2),Vector2(1,1)]
	},
	3:  {
		"title": "the challenge",
		"board_size": 4,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
	},	
	4:  {
		"title": "the crossroad",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
	},	
	5:  {
		"title": "the challenge 1",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)],
	},			
	6:  {
		"title": "the challenge 2",
		"board_size": 6,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)]
	},	
	7:  {
		"title": "the secret",
		"board_size": 8,
		"starting_position": null,
		"target_position": null,
		"blocked_index":[Vector2(2,2),Vector2(1,1)]
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

func _on_score_added(value):
	game_data.score += value

func _on_move_performed(value):
	game_data.max_move -= value	

func _on_money_amount_change(value):
	game_data.money += value


## Global Function
# Button Styler
func button_styler(btn:Button, btn_label:RichTextLabel, theme:String, size:String, disabled:bool, fit_width:bool):
	var border_size:= 1
	var border_size_focused:= 3
	var text_shadow_offset:= 4
	var shadow_size:= 1
	var button_shadow_offset:= 3
	var button_shadow_offset_pressed:= 3
	var button_margin:= 24
	
	var button_style = {
		"purple": {
			"bg_color" : Color.SLATE_BLUE,
			"bg_color_hover" : Color.MEDIUM_PURPLE,
			"bg_color_pressed" : Color.REBECCA_PURPLE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0)
,

			
			"text_color" : Color.GHOST_WHITE,
			"text_color_hover" : Color.GHOST_WHITE,
			"text_color_disabled" : Color.WEB_GRAY,
			
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			
			"text_shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			
			"border_color_focus": Color.LAVENDER
		},
		"purple_secondary": {
			"bg_color" : Color.LAVENDER,
			"bg_color_hover" : Color.WHITE,
			"bg_color_pressed" : Color.WHITE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0)
,
			
			"text_color" : Color.DARK_SLATE_BLUE,
			"text_color_hover" : Color.DARK_SLATE_BLUE,
			"text_color_disabled" : Color.WEB_GRAY,
			
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			
			"text_shadow_color": Color.GRAY,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			
			"border_color_focus": Color.PLUM
		},		
		"green": {
			"bg_color" : Color.LAWN_GREEN,
			"bg_color_hover" : Color.GREEN_YELLOW,
			"bg_color_pressed" : Color.LIME_GREEN,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0)
,
			
			"text_color" : Color.DARK_GREEN,
			"text_color_hover" : Color.FOREST_GREEN,
			"text_color_disabled" : Color.WEB_GRAY,
			
			"shadow_color": Color.DARK_GREEN,
			"shadow_color_disabled" : Color.DIM_GRAY,
			
			"text_shadow_color": Color.LIME_GREEN,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			
			"border_color_focus": Color.YELLOW
		},
		"red": {
			"bg_color" : Color.CRIMSON,
			"bg_color_hover" : Color.ORANGE_RED,
			"bg_color_pressed" : Color.FIREBRICK,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0)
,

			
			"text_color" : Color.GHOST_WHITE,
			"text_color_hover" : Color.GHOST_WHITE,
			"text_color_disabled" : Color.WEB_GRAY,
			
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			
			"text_shadow_color": Color.DARK_SLATE_BLUE,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			
			"border_color_focus": Color.LIGHT_CORAL
		},		
		"red_secondary": {
			"bg_color" : Color.LAVENDER,
			"bg_color_hover" : Color.WHITE,
			"bg_color_pressed" : Color.WHITE,
			"bg_color_disabled" : Color.GRAY,
			"bg_color_focus" : Color(0.0, 0.0, 0.0, 0.0)
,
			
			"text_color" : Color.ORANGE_RED,
			"text_color_hover" : Color.CRIMSON,
			"text_color_disabled" : Color.WEB_GRAY,
			
			"shadow_color": Color.DARK_SLATE_BLUE,
			"shadow_color_disabled" : Color.DIM_GRAY,
			
			"text_shadow_color": Color.GRAY,
			"text_shadow_color_disabled": Color.LIGHT_GRAY,
			
			"border_color_focus": Color.LAVENDER
		},		
	}
	var button_size ={
		"small": {
			"font_size": 28,
			"button_height": 48,
			"corner_radius": 3
		},
		"medium": {
			"font_size": 36,
			"button_height": 56,
			"corner_radius": 3
		},
		"big": {
			"font_size": 40,
			"button_height": 64,
			"corner_radius": 3
		}		
	}

	## DISABLED
	var disabled_style := StyleBoxFlat.new()
	# Style corner radius
	disabled_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	disabled_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	disabled_style.corner_radius_top_left = button_size[size]["corner_radius"]
	disabled_style.corner_radius_top_right = button_size[size]["corner_radius"]
	disabled_style.bg_color = button_style[theme]["bg_color_disabled"]
	# Style shadow
	disabled_style.shadow_size = shadow_size
	disabled_style.shadow_offset.y = button_shadow_offset
	disabled_style.shadow_color = button_style[theme]["shadow_color_disabled"]
	# Style border
	disabled_style.border_width_bottom = border_size
	disabled_style.border_width_top = border_size
	disabled_style.border_width_left = border_size
	disabled_style.border_width_right = border_size
	disabled_style.border_color = button_style[theme]["shadow_color_disabled"]
	btn.add_theme_stylebox_override("disabled", disabled_style)		
	
	## NORMAL
	var normal_style := StyleBoxFlat.new()
	## Style corner radius
	normal_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	normal_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	normal_style.corner_radius_top_left = button_size[size]["corner_radius"]
	normal_style.corner_radius_top_right = button_size[size]["corner_radius"]
	normal_style.bg_color = button_style[theme]["bg_color"]
	## Style shadow
	normal_style.shadow_size = shadow_size
	normal_style.shadow_offset.y = button_shadow_offset
	normal_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	normal_style.border_width_bottom = border_size
	normal_style.border_width_top = border_size
	normal_style.border_width_left = border_size
	normal_style.border_width_right = border_size
	normal_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("normal", normal_style)
	
	## HOVER
	var hover_style := StyleBoxFlat.new()
	## Style corner radius
	hover_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	hover_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	hover_style.corner_radius_top_left = button_size[size]["corner_radius"]
	hover_style.corner_radius_top_right = button_size[size]["corner_radius"]
	hover_style.bg_color = button_style[theme]["bg_color_hover"]
	## Style shadow
	hover_style.shadow_size = shadow_size
	hover_style.shadow_offset.y = button_shadow_offset
	hover_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	hover_style.border_width_bottom = border_size
	hover_style.border_width_top = border_size
	hover_style.border_width_left = border_size
	hover_style.border_width_right = border_size
	hover_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("hover", hover_style)
	
	## PRESSED
	var pressed_style := StyleBoxFlat.new()
	## Style corner radius
	pressed_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	pressed_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	pressed_style.corner_radius_top_left = button_size[size]["corner_radius"]
	pressed_style.corner_radius_top_right = button_size[size]["corner_radius"]
	pressed_style.bg_color = button_style[theme]["bg_color_pressed"]
	## Style shadow
	pressed_style.shadow_size = shadow_size
	pressed_style.shadow_offset.y = button_shadow_offset_pressed
	pressed_style.shadow_color = button_style[theme]["shadow_color"]
	## Style border
	pressed_style.border_width_bottom = border_size
	pressed_style.border_width_top = border_size
	pressed_style.border_width_left = border_size
	pressed_style.border_width_right = border_size
	pressed_style.border_color = button_style[theme]["shadow_color"]
	btn.add_theme_stylebox_override("pressed", pressed_style)	
	
	var hover_pressed_style := StyleBoxFlat.new()
	# Style corner radius
	hover_pressed_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_top_left = button_size[size]["corner_radius"]
	hover_pressed_style.corner_radius_top_right = button_size[size]["corner_radius"]
	hover_pressed_style.bg_color = button_style[theme]["bg_color_pressed"]
	# Style shadow
	hover_pressed_style.shadow_size = shadow_size
	hover_pressed_style.shadow_offset.y = button_shadow_offset_pressed
	hover_pressed_style.shadow_color = button_style[theme]["shadow_color"]
	# Style border
	hover_pressed_style.border_width_bottom = border_size
	hover_pressed_style.border_width_top = border_size
	hover_pressed_style.border_width_left = border_size
	hover_pressed_style.border_width_right = border_size
	hover_pressed_style.border_color = button_style[theme]["shadow_color"]	
	btn.add_theme_stylebox_override("hover_pressed", hover_pressed_style)	
	
	## FOCUS
	var focus_style := StyleBoxFlat.new()
	# Style corner radius
	focus_style.corner_radius_bottom_left = button_size[size]["corner_radius"]
	focus_style.corner_radius_bottom_right = button_size[size]["corner_radius"]
	focus_style.corner_radius_top_left = button_size[size]["corner_radius"]
	focus_style.corner_radius_top_right = button_size[size]["corner_radius"]
	focus_style.bg_color = button_style[theme]["bg_color_focus"]
	# Style shadow
	focus_style.shadow_size = shadow_size
	focus_style.shadow_offset.y = button_shadow_offset
	focus_style.shadow_color = button_style[theme]["shadow_color"]
	# Style border
	focus_style.border_width_bottom = border_size_focused
	focus_style.border_width_top = border_size_focused
	focus_style.border_width_left = border_size_focused
	focus_style.border_width_right = border_size_focused
	focus_style.border_color = button_style[theme]["border_color_focus"]
	focus_style.draw_center = false
	btn.add_theme_stylebox_override("focus", focus_style)		
	
	## BTN LABEL
	btn_label.add_theme_color_override("default_color", button_style[theme]["text_color"])
	btn_label.add_theme_color_override("font_shadow_color", button_style[theme]["text_shadow_color"])
	btn_label.add_theme_font_size_override("normal_font_size", button_size[size]["font_size"])
	btn_label.add_theme_constant_override("shadow_offset", text_shadow_offset)
	btn_label.custom_minimum_size.x = btn_label.get_theme_font("normal_font").get_string_size(strip_bbcode(btn_label.text),HORIZONTAL_ALIGNMENT_CENTER,-1,button_size[size]["font_size"]).x
	
	if disabled:
		btn.disabled = true
		btn_label.add_theme_color_override("default_color", button_style[theme]["text_color_disabled"])
		btn_label.add_theme_color_override("font_shadow_color", button_style[theme]["text_shadow_color_disabled"])
		
	btn.custom_minimum_size.y = button_size[size]["button_height"]
	if fit_width:
		btn.custom_minimum_size.x = btn_label.custom_minimum_size.x + button_margin


func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)
