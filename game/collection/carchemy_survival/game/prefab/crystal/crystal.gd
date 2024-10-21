extends Area2D


@onready var root_node = get_tree().get_root().get_child(0)

enum crystal_type{ICE,FIRE}

@export var crystal = crystal_type.ICE

var crystal_ice_sprite = preload("res://collection/carchemy_survival/content/sprite/crystal_ice.png")
var crystal_fire_sprite = preload("res://collection/carchemy_survival/content/sprite/crystal_fire.png")

@onready var crystal_label = $crystal_label
@onready var crystal_sprite_node = $Sprite2D
@onready var crystal_glow = $crystal_glow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crystal_label.modulate.a = 0.0
	match crystal:
		crystal_type.ICE:
			crystal_label.text = "ice crystal"
			crystal_sprite_node.texture = crystal_ice_sprite
			crystal_glow.color = Color.AQUAMARINE
		crystal_type.FIRE:
			crystal_label.text = "fire crystal"
			crystal_sprite_node.texture = crystal_fire_sprite
			crystal_glow.color = Color.YELLOW


func _on_body_entered(_body: Node2D) -> void:
	match crystal:
		crystal_type.ICE:	
			root_node.emit_signal("crystal_hit", "ice_crystal")
		crystal_type.FIRE:
			root_node.emit_signal("crystal_hit", "fire_crystal")			


func _on_hint_area_body_entered(_body: Node2D) -> void:
	crystal_label.modulate.a = 1.0


func _on_hint_area_body_exited(body: Node2D) -> void:
	crystal_label.modulate.a = 0.0
