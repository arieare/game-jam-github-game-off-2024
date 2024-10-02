extends Node
class_name CommonHitStopSlowMo

'''
stop or slow time for a short while
'''

func slow_mo(time_scale: float, slow_mo_lerp:float):
	# time_scale 1.0 is normal
	# slow_mo_lerp dictate the speed towards slow_mo
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(Engine, "time_scale", time_scale, slow_mo_lerp)

func hit_stop(duration_msec:float):
	OS.delay_msec(duration_msec)
