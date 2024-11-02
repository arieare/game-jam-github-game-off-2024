extends RigidBody3D

@export var interaction:component_interaction_area
@export var hurt_box:hurt_box_3d
var is_hurt_box: bool = false
var knockback_vector: float = 0.0
var knockback_decay: float = 0.1
var knockback_timer: float = 0.0

func _ready() -> void:
	interaction.interact = Callable(self, "_test_interact")
	#hurt_box.attack = Callable(self, "_test_attack")
	
func _physics_process(delta: float) -> void:
	if knockback_vector > 0:
		#self.linear_velocity = Vector3(0,knockback_vector,0)
		self.apply_central_impulse(Vector3(0,knockback_vector,0) * self.mass)
		knockback_vector -= knockback_decay * delta

func _test_interact():
	print("hello")

func _test_attack():
	if knockback_vector <= 0:
		knockback_vector = 0.5
		knockback_timer = knockback_vector
	print("ack!")
