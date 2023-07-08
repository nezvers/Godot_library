## Node to expose a state resorce to AnimationPlayer or other nodes.
## Add state type to make it easier to set _next_state from AnimationPlayer
extends Node

## Useful method to expose a state resource to AnimationPlayer
@export var state_resource:StateMachineResource

## Useful method to expose a state resource to AnimationPlayer
func set_state(_next_state:int)->void:
	state_resource.transition(_next_state)
