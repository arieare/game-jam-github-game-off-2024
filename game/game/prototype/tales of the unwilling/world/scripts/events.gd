extends Node

# Player Signals
signal player_state_changed(currentState, previousState)
signal player_ability_warping_state_changed(warpingState)
signal player_stamina_changed(staminaValue, staminaStateName)
signal player_global_position(position)

# Weapon Signals
signal weapon_bow_state_changed(currentState)
signal weapon_arrow_spawned(arrowBullet)

# Warping Signals
signal body_warp_scanned(bodies)
signal body_warp_removed(bodies)
signal body_warp_selected(bodies)
