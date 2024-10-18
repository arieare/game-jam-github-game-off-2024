class_name util_bob_sine

var time: float
var amount: float
var decay := 1.0
var cycle_range: float

## return sinusidal cycle value per delta
func calculate(delta, frequence:float, amplitude:float):
	amount = 1.0
	time += delta
	amount *= decay	
	cycle_range = sin(time*frequence)*amplitude*amount
	return cycle_range
