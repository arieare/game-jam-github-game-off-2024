class_name State
extends Node

func enter(actor):
	pass
	# Initialize idle state (e.g., play idle animation)

func update(delta, actor):
	pass
	# Implement idle logic

func exit(actor):
	actor.ChangeAndEmitPreviousPlayerState(actor.currentState)
	pass
	# Cleanup when exiting idle state
