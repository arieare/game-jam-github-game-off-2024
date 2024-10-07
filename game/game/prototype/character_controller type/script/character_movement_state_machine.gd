extends ModularStateMachine


## ======
# I liked this approach slightly better because it didn't require me to know ahead what are the list of states.
# Each states are responsible for transitioning to another states.
## ======
func _process(delta):
	super(delta)
	apply_gravity(entity)
	entity.move_and_slide()
func _physics_process(delta):
	super(delta)
	get_dir()
	
##====== FALL
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
func apply_gravity(entity):
	if !entity.is_on_floor():
		entity.velocity.y -= GRAVITY
		

func get_dir():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
