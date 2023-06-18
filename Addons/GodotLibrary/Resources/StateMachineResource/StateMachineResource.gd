## Simple signal based state machine, that allow to cancel transitioning between 
## certain changes to interupt with different state instead.
## Tip: Adding a variable type to state variables will make easier to work with. They are generic for library.
## Tip: Be mindful about keeping a resource in the memory for it not to loose property values.
class_name StateMachineResource
extends Resource

## Emitted when transition is aborted because _next_state is the same as current state.
signal state_repeat
## Emitted when assigned next_state. At this point it is possible to cancel transitioning 
## by setting cancel_enter to true.
signal state_exit
## Emitted when state has been assigned.
signal state_enter
## Emitted when transitioning has been canceled and is possible to inject override state.
signal state_enter_canceled
## Utility signal for state machine related signalling outside transitioning function.
signal continue_transition

## Current state
var state
## Useful for detecting specific transition to interupt.
var next_state
## Useful for detecting specific transition to interupt.
var previous_state
## Flag to transition logic to cancel transitioning. Used during state_exit 
var cancel_enter:bool = false

## Method to transition between states.
func transition(_next_state)->void:
	if _next_state == state:
		state_repeat.emit()
#		print("Repeat: ", state_names[_next_state])
		return
	next_state = _next_state
	state_exit.emit()
	if cancel_enter:
		cancel_enter = false
#		print("Blocked: ", state_names[state], " to ", state_names[next_state])
		state_enter_canceled.emit()
		return
	
	previous_state = state
	state = next_state
#	print("New state: ", state_names[state])
	state_enter.emit()
