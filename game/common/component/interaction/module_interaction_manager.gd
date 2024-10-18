extends Node3D
class_name module_interaction_manager

## List of game node
@export var interaction_label: Label
@export var label_container: Control

const BASE_INSTRUCTION_TEXT: String = "to "

var active_interactive_area: Array = []
var can_interact: bool = true

func register_interaction_area(area: component_interaction_area):
	active_interactive_area.push_back(area)

func unregister_interaction_area(area: component_interaction_area):
	var index = active_interactive_area.find(area)
	if index != -1:
		active_interactive_area.remove_at(index)

func _process(delta: float) -> void:
	if active_interactive_area.size() > 0 and can_interact:
		active_interactive_area.sort_custom(_sort_by_distance_to_player)
		interaction_label.text = BASE_INSTRUCTION_TEXT + active_interactive_area[0].interaction_name
		
		var screen_space_coordinate = get_viewport().get_camera_3d().unproject_position(active_interactive_area[0].global_position)
		#var screen_space_coordinate = root.cam.unproject_position(root.player.global_position)
		#interaction_label.global_position = Vector2(active_interactive_area[0].global_position.x, active_interactive_area[0].global_position.y)
		label_container.position = screen_space_coordinate
		label_container.position.x -= label_container.size.x / 2
		label_container.position.y = screen_space_coordinate.y - 100
		label_container.show()
	else:
		label_container.hide()
		
func _sort_by_distance_to_player(area_1, area_2):
	
	var area_1_to_player = util.root.data_container.player.global_position.distance_to(area_1.global_position)
	var area_2_to_player = util.root.data_container.player.global_position.distance_to(area_2.global_position)
	return area_1_to_player < area_2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_interactive_area.size() > 0:
			can_interact = false	
			label_container.hide()
			await active_interactive_area[0].interact.call()
			can_interact = true
