extends Hittable

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var kindOf = EnemyType

func _ready():
	super()
	if kindOf.enemyName != null:
		self.set_name.call_deferred(kindOf.enemyName)

func _process(delta):
	CheckIfHit(delta)
	if isDestroyed:
		queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func CheckIfHit(delta):
	if isHit:
		KnockBack(delta)
