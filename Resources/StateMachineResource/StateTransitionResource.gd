## Holds information of transition chain
class_name StateTransitionResource
extends Resource

## If something needs chain specific event
signal chain_used

## Return array of state_id for each state to travel
## Array content will be used to match routes
func get_chain()->Array[int]:
	return[]
