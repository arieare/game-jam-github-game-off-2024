class_name util_slow_mo extends Node

## slow time for a short while
## time_scale 1.0 is normal, slow_mo_lerp dictate the speed towards slow_mo
func start(time_scale: float, slow_mo_lerp:float): 
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(Engine, "time_scale", time_scale, slow_mo_lerp)
