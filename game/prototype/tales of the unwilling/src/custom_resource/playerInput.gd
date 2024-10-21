extends Resource
class_name PlayerInput

var currentInput = inputStates.INPUT_JUMPING

var inputJumpPressStart
var inputJumpPress

var inputGlidePress

var inputSprintPress
var inputMoveRightPress
var inputMoveLeftPress
var movementVector

var inputMoveDownPress
var inputDashPressStart

var inputWarpPressStart
var inputWarpPress
var inputWarpPressRelease

enum inputStates {
	INPUT_GLIDING, INPUT_JUMPING, INPUT_SPRINTING, INPUT_DASHING
}

func InputHandler():
	
	inputJumpPressStart = Input.is_action_just_pressed("input_jump")
	inputJumpPress = Input.is_action_pressed("input_jump")
	inputMoveRightPress = Input.is_action_pressed("input_move_right")
	inputMoveLeftPress = Input.is_action_pressed("input_move_left")
	inputMoveDownPress = Input.is_action_pressed("input_move_down")
	movementVector = Input.get_axis("input_move_left", "input_move_right")
	inputSprintPress = Input.is_action_pressed("input_sprint")
	inputGlidePress = Input.is_action_pressed("input_glide")
	inputDashPressStart = Input.is_action_just_pressed("input_dash")
	inputWarpPressStart = Input.is_action_just_pressed("input_warp")
	inputWarpPress = Input.is_action_pressed("input_warp")
	inputWarpPressRelease = Input.is_action_just_released("input_warp")
