class_name State
extends Node


signal transition_to_state(state: State, new_state_name: StringName)

@onready var entity = get_parent().get_entity()

func _ready():
	print(entity)
	pass # Replace with function body.

func enter_state():
	pass # Replace with function body.
	
func process_state(_delta:float):
	pass

func physics_process_state(_delta:float):
	state_transition_logic()
	pass
	
func exit_state():
	pass

func state_transition_logic():
	pass
