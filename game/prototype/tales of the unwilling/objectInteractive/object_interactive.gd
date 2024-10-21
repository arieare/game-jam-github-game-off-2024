extends Hittable

func _ready():
	super()
	
func _process(delta):
	if isDestroyed:
		queue_free()
