class_name StateMachine
extends Node

@export var state: State
@export var actor: Node
#@export var animator: AnimatedSprite2D

var current_state = null
var previous_state = null

func _ready():
	set_state(state)
	get_previous_state()

func set_state(new_state):
	if current_state != null:
		current_state.exit(actor)
#		current_state.queue_free()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(actor)

func get_previous_state():
	return previous_state

func update_state(delta):
	current_state.update(delta, actor)

func _process(delta):
	update_state(delta)
