extends StateMachine

func _assign_states():
	state_list = [&"idle",&"move",&"jump",&"fall",&"run"]

func _state_logic(_delta:float):
	match state:
		states.idle, states.move:
			controller.apply_gravity()
			controller.ground_move()
			controller.apply_jump(_delta)
		#states.move:
			#controller.apply_gravity()
			#controller.ground_move(controller.character_parent)			
			#controller.apply_jump(_delta, controller.character_parent)
		states.jump:
			controller.apply_gravity()
			controller.apply_jump(_delta)
		states.fall:
			controller.apply_gravity()
		states.run:
			controller.apply_gravity()
			controller.ground_move()			

func _get_transition(_delta):
	match state:
		states.idle:
			if !controller.character_parent.is_on_floor():
				if controller.character_parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			else:
				if controller.character_parent.velocity.x != 0 or controller.character_parent.velocity.z != 0:
					return states.move
			
		states.move:
			if !controller.character_parent.is_on_floor():
				if controller.character_parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			else:
				if controller.character_parent.velocity.x == 0 or controller.character_parent.velocity.z == 0:
					return states.idle
			
		states.jump:
			if controller.character_parent.is_on_floor():
				if controller.character_parent.velocity.x == 0 or controller.character_parent.velocity.z == 0:
					return states.idle
				else:
					return states.move		
			else:
				if controller.character_parent.velocity.y > 0:
					return states.fall
		
		states.fall:
			if controller.character_parent.is_on_floor():
				if controller.character_parent.velocity.x == 0 or controller.character_parent.velocity.z == 0:
					return states.idle
				else:
					return states.move
			else:
				if controller.character_parent.velocity.y < 0:
					return states.jump
				
		states.run:
			if !controller.character_parent.is_on_floor():
				if controller.character_parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			else:
				if controller.character_parent.velocity.x == 0 or controller.character_parent.velocity.z == 0:
					return states.idle
