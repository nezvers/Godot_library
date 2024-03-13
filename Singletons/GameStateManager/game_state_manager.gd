extends Node

@export var game_state_resource:StateMachineResource
@export var initial_state_id:int = 0
@export var task_callback_list:Array[TaskCallbackResource]
@export var task_signal_list:Array[TaskSignalResource]

func _ready()->void:
	call_deferred("start_state")

func start_state()->void:
	game_state_resource.state = 0
	game_state_resource.state_enter.emit()
	
	TaskCallbackResource.test_single_tick_loop()






