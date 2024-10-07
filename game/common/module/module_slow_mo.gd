extends Node
class_name module_slow_mo

'''
slow time for a short while
'''

func slow_mo(time_scale: float, slow_mo_lerp:float): # time_scale 1.0 is normal, slow_mo_lerp dictate the speed towards slow_mo
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(Engine, "time_scale", time_scale, slow_mo_lerp)
