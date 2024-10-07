# State Machine

This document describe how the state machine works. Largely adapted from this [tutorial](https://github.com/Alzzary/state-machine-tutorial-starter/blob/main/scripts/Statemachine.gd  ).

- There are onnly one main scripts `state_machine_class.gd` -> Extend this to a `stateMachine` node attached to the character/object parent.
- parent is captured within `@onready` through parent = get_parent(), so make sure the `stateMachine` node is a direct child of the character/object
