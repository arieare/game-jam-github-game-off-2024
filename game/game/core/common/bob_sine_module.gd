extends Node
class_name bob_sine_module

'''
return sinusidal value per delta, useful for back and forth movement
'''

var time: float
var frequence: float # sin speed
var amplitude: float # value range
var amount: float
var decay = 1.0
var range: float

func cycle(delta, frequence, amplitude):
	amount = 1.0
	time += delta
	amount *= decay	
	range = sin(time*frequence)*amplitude*amount
	return range
