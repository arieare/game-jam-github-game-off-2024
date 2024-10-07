extends Node
class_name module_hit_stop

'''
stop time for a short while
'''

func hit_stop(duration_msec:float):
	OS.delay_msec(duration_msec)
