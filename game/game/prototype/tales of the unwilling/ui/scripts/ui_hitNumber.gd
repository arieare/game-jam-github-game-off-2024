extends Node2D

@onready var hitLabel:Label = $hitLabelContainer/hitLabel
@onready var hitLabelContainer:Node2D = $hitLabelContainer
@onready var animation:AnimationPlayer = $AnimationPlayer

func _ready():
	set_process_input(true)
	set_process_unhandled_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Raise(value:String, spawnPos:Vector2, popHeight:float, popSpread:float):
	hitLabel.text = value
	animation.play("popUpAndFade")
	
	var tween = get_tree().create_tween()
	var endPos = Vector2(randf_range(-popSpread, popSpread), -popHeight) + spawnPos
	var tweenDuration = animation.get_animation("popUpAndFade").length
	
	tween.tween_property(hitLabelContainer,"position",endPos,tweenDuration).from(spawnPos)
	
func Destroy():
	animation.stop()
	if is_inside_tree():
		queue_free()
