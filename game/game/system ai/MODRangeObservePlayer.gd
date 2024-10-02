extends Area3D
var timer: Timer
var hitEntities
var enterObserverRange = false
var observeTimerOff = false
@export var observeRadius = 10

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(self._onObserveTimerRunout)
	get_child(0).shape.set_radius(observeRadius)

func _process(delta):
	if enterObserverRange == false:
		hitEntities = get_overlapping_bodies()
		if hitEntities:
			enterObserverRange = true
			timer.wait_time = 0.5
			timer.one_shot = true
			timer.start()
	else:
		hitEntities = get_overlapping_bodies()
		if not hitEntities:
			enterObserverRange = false
			observeTimerOff = false
		if observeTimerOff:
			var target_position = hitEntities[0].global_transform.origin
			var new_transform = self.get_parent().global_transform.looking_at(target_position, Vector3.UP)
			var distance = self.get_parent().global_position.distance_to(hitEntities[0].global_position)
			self.get_parent().global_transform  = self.get_parent().global_transform.interpolate_with(new_transform, 20/(distance*2) * get_process_delta_time())			

func _onObserveTimerRunout():
	observeTimerOff = true
