extends StateMachine

@onready var READY = $READY
@onready var DRAW = $DRAW
@onready var AIM = $AIM
@onready var SHOOT = $SHOOT

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
	
func update_state(delta):
	current_state.update(delta, actor)

func _process(delta):
	update_state(delta)

func get_previous_state():
	return previous_state
