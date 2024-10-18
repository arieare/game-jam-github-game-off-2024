# the tiny tale

## TODO
- [ ] dialog system
- [ ] quest system
- [ ] hitbox
- [ ] disassemble artefact items
- [x] movement: zipzap
- [ ] movement: warp to enemy
- [ ] skill: aim hold
- [ ] skill: combo melee
- [ ] game: victory
- [ ] game: death


## project folder
- app
- content: hold all the assets
- game: hold all game related scenes and code
- ui: hold all ui related scenes and code

## game structure
|_ root
|_ app
|_ game
|_ common
  |_ pid_controller
  |_ day_time_system
  |_ input_setting
  |_ interaction_manager
|_ ui

## key modules
### interactive modules
- `interaction_area_module` : a plug and play module to make game object interactable and call a specific interaction function.

### camera modules
- `cam_shake_module` 		: enable camera shake effect to camera
- `cam_pixel_3d_module` 	: enable dither and pixelation effect for the 'camera lens'

# GDD
- the game is about an astronout crash landing into an island in a planet
- player needs to fix the rocket by collecting artefacts for fixing the rocket and going back home.
- the incident where the rocket blow up in the atmosphere turns out spreads an alien spore which makes the peaceful island a parasite monster invested place.
- can the player go back home after befriending the locals?


Script structure from https://github.com/abmarnie/godot-architecture-organization-advice:
	
01. @tool
02. class_name (PascalCase)
03. extends
04. # docstring

05. signals (snake_case)
06. enums (PascalCase, members are CONSTANT_CASE)
07. constants (CONSTANT_CASE)
08. @export variables (snake_case)
09. public variables (non-underscore-prefixed snake_case)
10. private variables (underscore-prefixed _snake_case)
11. @onready variables (snake_case)

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods (underscore-prefixed _snake_case)
16. public methods (non-underscore-prefixed snake_case)
17. private methods (underscore-prefixed _snake_case)
18. subclasses (PascalCase)
