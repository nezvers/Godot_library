## Information needed for a state management
class_name StateResource
extends  Resource

## Should be emited from succesful can_enter callback
signal state_entered
## Should be emited from succesful can_exit callback
signal state_exited
## Should be emited from update callback
signal state_updated

## Array of resources holding state_id array to set a transition chain
@export var transition_chains:Array[StateTransitionResource]

## Only one owner can have a callback. Return bool if is entering.
var can_enter:Callable
## Only one owner can have a callback. If state needs a callback to exit.
var can_exit:Callable
## Only one owner can have a callback. If state needs a callback to update.
var update:Callable

## Get an int representing state.
## Extend class to have custom value converted to int
func get_state_id()->int:
	return 0

