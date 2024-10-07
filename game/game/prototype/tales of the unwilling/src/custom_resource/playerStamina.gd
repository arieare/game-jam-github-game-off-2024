extends Resource
class_name PlayerStamina

@export var maxStamina: int
@export var refillRate :int = 100

var currentStamina = maxStamina

# STAMINA STATE ENUMS
enum staminaState {
	FULL, EMPTY, CHANGED
}

var currentStaminaState: staminaState = staminaState.FULL

func HandleStaminaStateTransitions() -> void:
	match currentStaminaState:
		staminaState.FULL:
			if currentStamina < maxStamina:
				currentStaminaState = staminaState.CHANGED
			elif currentStamina == 0:
				currentStaminaState = staminaState.EMPTY

		staminaState.CHANGED:
			if currentStamina == 0:
				currentStaminaState = staminaState.EMPTY
			elif currentStamina == maxStamina:
				currentStaminaState = staminaState.FULL
		
		staminaState.EMPTY:
			if currentStamina < maxStamina:
				currentStaminaState = staminaState.CHANGED
			elif currentStamina == maxStamina:
				currentStaminaState = staminaState.FULL	

func StaminaReset():
	currentStamina = maxStamina

func Drain(amount):
	currentStamina = max(0, currentStamina - amount)

func Rejuvenate(amount):
	currentStamina = min(maxStamina, currentStamina + amount)
