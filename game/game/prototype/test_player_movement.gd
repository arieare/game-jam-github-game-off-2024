extends Node3DPlus

@export var light:DirectionalLight3D

func _ready() -> void:
	root.light = light
