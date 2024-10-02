extends Control

@onready var root_node = get_tree().get_root().get_child(0)
@export var player:CharacterBody2D
@export var stage_node: Node2D
@onready var car_id_label_node = $car_id
@onready var game_prompt_node = $game_prompt

func _ready() -> void:
	stage_node.connect("arcade_state",on_arcade_state_change)

func _physics_process(_delta: float) -> void:
	# Follow car
	car_id_label_node.position.x = player.position.x - 40
	car_id_label_node.position.y = player.position.y - 30

	$velocity_meter.text = str(snapped(player.velocity.length(), 1.0))
	$elapsed_time.text = str(snapped(stage_node.elapsed_timer, 0.1))
	
	if player.velocity.length() < 50.0:
		$velocity_meter.add_theme_color_override("font_color",Color.RED)	
	else:
		$velocity_meter.add_theme_color_override("font_color",Color.WHITE)			
	
	
func on_arcade_state_change(state_message):
	game_prompt_node.text = state_message
