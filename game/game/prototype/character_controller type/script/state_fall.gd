extends State



func state_transition_logic():
	if entity.is_on_floor():
		if get_parent().get_dir() == Vector2.ZERO:
			transition_to_state.emit(self, &"idle")
		else:
			transition_to_state.emit(self, &"groundmove")
	else:
		transition_to_state.emit(self, &"jump")
