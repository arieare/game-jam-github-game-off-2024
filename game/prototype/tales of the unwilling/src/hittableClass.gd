class_name Hittable
extends CharacterBody2D

#@export var type: ObjectType
@export var health: HealthPoint
@export var objectSprite: AnimatedSprite2D
#@onready var hitNumber = preload("res://ui/ui_hit_number.tscn")

var knockBack = Vector2.ZERO
var isHit = false
var isDestroyed = false
var hitDirection

func _ready():
	health.HealthReset()

func HitBy(attacker):
	CheckIfShouldBeDead()
	if is_instance_valid(attacker):
		var dmg = attacker.damagePoint
		var pos = attacker.position
		health.Damage(dmg)
		#ShowHitNumber(dmg)
		#globalFunc.FlashSprite(objectSprite,Vector3(1, 1, 1),1)
		#await get_tree().create_timer(0.1).timeout
		#if dmg > 10:
			#globalFunc.FreezeFrame(0.1)
			#var fx = vfx.spawnFx(vfx.smokeExplosion, pos)
		#globalFunc.FlashSprite(objectSprite,Vector3(1, 1, 1),0)
		InitKnockBack(pos)
	

func CheckIfShouldBeDead():
	if health.GetCurrentHealth() == 0:
#		globalFunc.TeleportSprite(objectSprite,0,1)
		isDestroyed = true
		return isDestroyed

#func ShowHitNumber(damagePoint):
	#var hit = hitNumber.instantiate()
	#var hitPosition = self.position
	#var current_animation = objectSprite.animation
	#var sprite_texture = objectSprite.sprite_frames.get_frame_texture(objectSprite.animation, 0)
	#hitPosition.y = hitPosition.y - (sprite_texture.get_size().y * objectSprite.scale.y / 2) - 5
	#get_parent().add_child(hit, true)
	#hit.Raise(str(damagePoint), hitPosition, 50.0, 20.0)

#func AimedAt():
	#globalFunc.OutlineSprite(objectSprite, 2)
#
#func AimReset():
	#globalFunc.OutlineSprite(objectSprite, 0)

func KnockBack(delta):
	var old_velocity = velocity
	knockBack = knockBack.move_toward(Vector2.ZERO, 100 * delta)
	velocity = knockBack
	move_and_slide()
	knockBack = velocity
	velocity = old_velocity
	isHit = false

func InitKnockBack(pos):
	isHit = true
	hitDirection = (self.position - pos).normalized()
	hitDirection.y = hitDirection.y / 2
	knockBack = hitDirection * 1000


func _on_hurt_box_area_entered(area):
	if area:
		HitBy(area.owner)
