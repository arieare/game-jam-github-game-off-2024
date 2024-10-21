extends Area2D

@onready var attack := Attack.new()

func _ready() -> void:
	attack.group = str(self.get_groups()[0])
