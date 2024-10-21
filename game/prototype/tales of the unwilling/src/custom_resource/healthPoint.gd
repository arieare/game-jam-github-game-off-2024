extends Resource
class_name HealthPoint

@export var maxHealth: int
@export var refillRate:int

var currentHealth = 0

# STAMINA STATE ENUMS
enum healthState {
	FULL, EMPTY, CHANGED
}

var currentHealthState: healthState = healthState.FULL

func HandleHealthStateTransitions() -> void:
	match currentHealth:
		healthState.FULL:
			if currentHealth < maxHealth:
				currentHealth = healthState.CHANGED
			elif currentHealth == 0:
				currentHealth = healthState.EMPTY

		healthState.CHANGED:
			if currentHealth == 0:
				currentHealth = healthState.EMPTY
			elif currentHealth == maxHealth:
				currentHealth = healthState.FULL
		
		healthState.EMPTY:
			if currentHealth < maxHealth:
				currentHealth = healthState.CHANGED
			elif currentHealth == maxHealth:
				currentHealth = healthState.FULL	

func HealthReset():
	currentHealth = maxHealth

func Damage(amount):
	currentHealth = max(0, currentHealth - amount)

func Heal(amount):
	currentHealth = min(maxHealth, currentHealth + amount)

func GetCurrentHealth():
	return currentHealth
