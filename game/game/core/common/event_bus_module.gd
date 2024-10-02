extends Node
class_name event_bus_module

#region app signals
signal change_scene
signal scene_ready
#endregion

#region state signals
signal game_state(current_state, previous_state)
signal play_state(current_state, previous_state)
#endregion

#region game signals

#endregion
