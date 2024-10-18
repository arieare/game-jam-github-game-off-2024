extends Area2D

var mouse_pos: Vector2
@onready var attack := Attack.new()

func _ready() -> void:
	attack.knockback_power = 1200
	attack.group = str(self.get_groups()[0])

func _process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	self.global_position = mouse_pos
	attack.position_2d = self.global_position
	
func _physics_process(delta: float) -> void:	
	if Input.is_action_pressed("blow"):
		print("click")
		#self.scale = Vector2(1,1)
		##self.monitorable = true
		##self.monitoring = true
	#else:
		#self.scale = Vector2(0,0)
		##self.monitorable = false
		##self.monitoring = true		
