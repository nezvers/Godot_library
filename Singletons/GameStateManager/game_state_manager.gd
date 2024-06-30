extends Node

@export var game_state_resource:StateMachineResource
@export var initial_state_id:GameState.states

func _ready()->void:
	call_deferred("start_state")

func start_state()->void:
	game_state_resource.transition(initial_state_id)
	
	TaskCallbackResource.test_single_tick_loop()






