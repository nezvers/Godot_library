extends Node

@export var game_state_resource:StateMachineResource
@export var initial_state_id:int = 0

func _ready()->void:
	call_deferred("start_state")

func start_state()->void:
	game_state_resource.state = 0
	game_state_resource.state_enter.emit()
	



