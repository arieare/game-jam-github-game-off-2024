extends Node2D

signal core_crystal_hit
signal change_scene_to_game
signal change_scene_to_main_menu
signal times_up
signal crystal_hit


var player : Node

## Global variable
# Game class_state
enum GAME_STATE {START, RUNNING, PAUSE, OVER}
var prev_game_state = GAME_STATE.START
var current_game_state:GAME_STATE = GAME_STATE.START :
	set(value):
		var prev_state = current_game_state
		if current_game_state != value:
			current_game_state = value
			#self.game_state.emit(current_game_state)	

enum game_state {MAINMENU, GAMESTART, GAMEOVER}
#var current_game_state
var next_scene
var game_score: float

#@onready var main_menu_node = preload("res://game/collection/game-carchemy-survival/scene/menu.tscn")
var is_main_menu_instanced: bool = false
var main_menu_instance

#@onready var gameplay_node = preload("res://game/collection/game-carchemy-survival/scene/arcade.tscn")

#@onready var gameover_node = preload("res://game/collection/game-carchemy-survival/scene/game_over.tscn")

#@export var runtime_node: Node

@export var transition_node:Node2D
var transition_animation : AnimationPlayer
var transition_curtain: ColorRect

## Level config
var level_timer: float = 0.0
var level_1_timer: float = 0.25 #in minutes

#func _ready() -> void:	
	##Input.set_custom_mouse_cursor(cursor_res)
	##connect("change_scene_to_game", on_scene_change_to_game)
	##connect("change_scene_to_main_menu", on_scene_change_to_main_menu)
	#connect("times_up", on_times_up)
	#current_game_state = GAME_STATE.START
	#transition_animation  = transition_node.get_child(0).get_child(1)
	#transition_curtain  = transition_node.get_child(0).get_child(0)	
	#transition_curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _physics_process(delta: float) -> void:
	match current_game_state:
		#game_state.MAINMENU:
			#$bgm/bgm.stop()
			#if 	$bgm/bgm_main_menu.is_playing() == false:
				#$bgm/bgm_main_menu.play()			
			#if !is_main_menu_instanced:
				#main_menu_instance = main_menu_node.instantiate()
				#runtime_node.add_child(main_menu_instance)
				#is_main_menu_instanced = true

		GAME_STATE.RUNNING:
			level_timer += delta
			

#func on_scene_change_to_game():
	#transition_out()
	#next_scene = gameplay_node
	#current_game_state = game_state.GAMESTART
	#game_score = 0.0
	#$bgm/bgm_main_menu.stop()
#
#func on_scene_change_to_main_menu():
	#next_scene = main_menu_node
	#current_game_state = game_state.MAINMENU
	#transition_out()
	#$bgm/bgm.stop()
#
#
#func on_scene_change_to_game_over():
#
	#next_scene = gameover_node	
	#current_game_state = game_state.GAMEOVER
	#transition_out()
	#
#
#func enter_new_scene():
	#runtime_node.get_child(0).queue_free()
	#runtime_node.add_child(next_scene.instantiate())
	#transition_curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#if next_scene == gameplay_node:
		#$bgm/bgm.stop()
		#$bgm/bgm.play()
	#transition_animation.play("transition_in")
	level_timer = 0.0

	
#func transition_out():
	#transition_animation.play("transition_out")
	#transition_curtain.mouse_filter = Control.MOUSE_FILTER_STOP

func on_times_up(score):
	game_score = score
	print(game_score)
	#next_scene = gameover_node	
	current_game_state = GAME_STATE.OVER
	#enter_new_scene()
	#on_scene_change_to_game_over()
	
	
