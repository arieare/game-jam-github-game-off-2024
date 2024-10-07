extends Node
class_name module_bob_sine

## return sinusidal value per delta, useful for back and forth movement
##
## @experimental

var time: float
#var frequence: float # sin speed
#var amplitude: float # value range
var amount: float
var decay = 1.0
var cycle_range: float

## return sinusidal cycle value per delta
func cycle(delta, frequence, amplitude):
	amount = 1.0
	time += delta
	amount *= decay	
	cycle_range = sin(time*frequence)*amplitude*amount
	return cycle_range
