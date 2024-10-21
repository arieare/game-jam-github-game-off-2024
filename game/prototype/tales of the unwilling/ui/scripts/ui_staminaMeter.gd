extends TextureProgressBar

func _ready():
	#events.connect("player_stamina_changed", OnPlayerStaminaChanged)
	#events.connect("player_global_position", OnPlayerPositionChanged)

	# Ensure the stamina UI is always visible on top of the screen
	set_process_input(true)
	set_process_unhandled_input(true)
	
	self.set_tint_under(Color(0,0,0,1))

func _process(_delta):
	pass

func OnPlayerStaminaChanged(newPlayerStamina, staminaState):
	self.value = newPlayerStamina
	if staminaState == "CHANGED":
		self.visible = true
	if staminaState == "FULL":
		self.set_tint_progress(Color(0,1,0,1))
		self.visible = false

func OnPlayerPositionChanged(playerPosition):
	self.position = playerPosition
	self.position.y = self.position.y - 30
	self.position.x = self.position.x - 25
