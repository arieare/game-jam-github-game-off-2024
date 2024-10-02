extends Sprite2D


var rng = RandomNumberGenerator.new()
var middle_point: Vector2
var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	middle_point = self.position
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = false
	timer.wait_time = 0.5
	self.add_child(timer)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if timer.time_left == 0.0:
		timer.start()
	if timer.time_left < 0.1:
		on_eye_timer_up()
		
		

func on_eye_timer_up():
	self.position.x = rng.randf_range(middle_point.x - 8.0, middle_point.x + 8.0)
	self.position.y = rng.randf_range(middle_point.y - 8.0, middle_point.y + 8.0)
