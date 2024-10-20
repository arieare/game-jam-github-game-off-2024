extends RigidBody2D #leaf_class

@export var hurt_box:hurt_box_2d
var is_hurt_box: bool = false
var knockback_vector: Vector2
@export var sprite: Sprite2D

var leaf_colors := [Color.WHITE,
		  Color.GRAY,
		  Color.DARK_GRAY,
			Color.WEB_GRAY]

func _ready() -> void:
	hurt_box.attack = Callable(self, "blow")
	sprite.modulate = leaf_colors.pick_random()

func blow(attack:Attack):
	if attack.group == "hit_box":
		knockback_vector = self.global_position.direction_to(attack.position_2d).normalized()
		self.apply_central_impulse(knockback_vector * -1 * attack.knockback_power/2)
	if attack.group == "environment_fire":
		await get_tree().create_timer(2).timeout
		sprite.modulate = Color.BLACK
		await get_tree().create_timer(1).timeout
		self.queue_free()
