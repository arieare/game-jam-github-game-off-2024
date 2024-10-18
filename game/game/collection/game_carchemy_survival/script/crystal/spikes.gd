extends Node2D
var spike_scene = ResourceLoader.load("res://game/collection/game_carchemy_survival/content/scene/spike.tscn")
@onready var root_node = get_tree().get_root().get_child(0)
var spike_array : PackedVector2Array = []
var spike_array_max_size : int = 10
var spike_timer: Timer
var spike_spawner: Timer
var is_spawn_spike : bool = false
@export var player: CharacterBody2D
@export var stage_node: Node2D

var is_spike_message_displayed: bool = false
var is_general_message_displayed: bool = false

func _ready() -> void:
	spike_spawner = Timer.new()
	spike_spawner.wait_time = 10.0
	spike_spawner.autostart = true
	spike_spawner.one_shot = false
	add_child(spike_spawner)
	spike_spawner.start()
	


func _physics_process(_delta: float) -> void:
	if snapped(spike_spawner.time_left, 0.01) == 1.00:
		is_spawn_spike = true
	elif spike_spawner.time_left < 1.0:
		is_spawn_spike = false
		
	if is_spawn_spike == true:
		
		if !is_spike_message_displayed:
			stage_node.emit_signal("arcade_state", "beware of spikes.")
			is_spike_message_displayed = true	
		else:
			if !is_general_message_displayed:
				stage_node.emit_signal("arcade_state", "survive as long as you can.")
				is_general_message_displayed = true		

		var new_spike = spike_scene.instantiate()
		new_spike.global_position.x = randi_range(20, 700)
		new_spike.global_position.y = randi_range(100, 300)	
		add_child(new_spike)		
		
		new_spike.get_child(2).disabled = true
		await get_tree().create_timer(1.0).timeout
		new_spike.get_child(2).disabled = false
