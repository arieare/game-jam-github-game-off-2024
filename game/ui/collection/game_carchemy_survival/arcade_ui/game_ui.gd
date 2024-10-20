extends Control

@onready var root_node = get_tree().get_root().get_child(0)
#@export var player:CharacterBody2D
@export var stage_node: Node2D
@onready var car_id_label_node = $car_id
@onready var game_prompt_node = $game_prompt

var wasd_asset = preload("res://content/collection/game_carchemy_survival/sprite/accessibility_key_wasd.png")
var arrow_asset = preload("res://content/collection/game_carchemy_survival/sprite/accessibility_key_arrow.png")
@export var control_ui: Control
var switch_counter: int = 0

func _physics_process(_delta: float) -> void:
	pass
	#car_id_label_node.position.x = util.root.data_container.get_child(0).player.position.x - 40
	#car_id_label_node.position.y = util.root.data_container.get_child(0).player.position.y - 30

	#$velocity_meter.text = str(snapped(util.root.data_container.get_child(0).player.velocity.length(), 1.0))
	#$elapsed_time.text = str(snapped(stage_node.elapsed_timer, 0.1))
	#
	#if util.root.data_container.get_child(0).player.velocity.length() < 50.0:
		#$velocity_meter.add_theme_color_override("font_color",Color.RED)	
	#else:
		#$velocity_meter.add_theme_color_override("font_color",Color.WHITE)			

func _process(delta: float) -> void:
	control_hint()	
	
func on_arcade_state_change(state_message):
	game_prompt_node.text = state_message

func control_hint():
	if switch_counter == 0:
		control_ui.get_child(0).texture = wasd_asset
		await get_tree().create_timer(0.5).timeout
		switch_counter = 1
	else:
		control_ui.get_child(0).texture = arrow_asset
		await get_tree().create_timer(0.5).timeout
		switch_counter = 0
	
	
	if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		await get_tree().create_timer(2.0).timeout
		control_ui.get_child(0).modulate.a = 0	
