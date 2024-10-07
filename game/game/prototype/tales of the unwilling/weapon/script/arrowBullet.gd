extends CharacterBody2D

@onready var player = get_tree().root.get_node("world/WorldEnvironment/player")
@onready var sprite = $Sprite2D
@onready var arrowHead = $arrowHead
@onready var warpScanner = $warpScanner
@onready var warpScanCollider = $warpScanner/warpScanCollider

var damagePoint = 15

func _ready():
	damagePoint = randi_range(1, damagePoint)

func _physics_process(delta):
	move_and_slide()
	self.scale.x = player.playerFacingDirection

func _on_arrow_head_body_entered(body):
	self.velocity = Vector2.ZERO
#	sprite.scale *= 1.5
	
	var fx = vfx.spawnFx(vfx.hit, global_position)
	fx.scale.x = scale.x
	
	queue_free()

func _on_warp_scanner_body_entered(body):
	events.emit_signal("body_warp_scanned", body)


func _on_warp_scanner_body_exited(body):
	events.emit_signal("body_warp_removed", body)

func AimedAt():
	globalFunc.OutlineSprite(sprite, 2)

func AimReset():
	globalFunc.OutlineSprite(sprite, 0)
