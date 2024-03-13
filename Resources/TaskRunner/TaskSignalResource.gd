class_name TaskSignalResource
extends Resource

## Signal to notify user when to respond to a task
signal task_started
## Signal to notify when TaskSignalResource completed a task
signal task_complete
## gets called with (result:Result, task_runner:TaskSignalResource = self)
signal callback_complete(result:Result, task_runner:TaskSignalResource)
## Holds bound values to send further when user calls task_next() 
signal callback_next(sibilings:Array[TaskSignalResource], index:int)

## Result of the task and options to handle errors
enum Result {
	SUCCESS, ## Returned if task it self is completed to the end
	CANCEL, ## Returned when a task is cancelled by task_cancel()
	ERROR, ## Returned when error is hit, like callback_complete isn't assigned
	}
## Child task array. Chain started with first entry
@export var children_tasks:Array[TaskSignalResource]
## Child tasks can stop further chain with ERROR and CANCEL results
@export var result_from_child:bool = true
## Next sibiling task can stop further chain with ERROR and CANCEL results
@export var result_from_next:bool = true

## User triggerable function to start transition to next task in the chain
func task_next()->void:
	if callback_next.is_null():
		print("TaskSignalResource: ERROR - callback_next is not assigned")
		return
	callback_next.emit()

## User triggerable function to cancel this task and return Result.CANCEL
func task_cancel()->void:
	print("TaskSignalResource: CANCEL - ", resource_name)
	var connections:Array[Dictionary] = callback_next.get_connections()
	for connection:Dictionary in connections:
		connection.signal.disconnect(connection.callable)
	callback_complete.emit(Result.CANCEL, self)

##  Entry function. Needs to receive of sibiling TaskSignalResources and index of a runner in that array
func task_start(sibilings:Array[TaskSignalResource], index:int)->void:	
	# Bind sibiling and index
	callback_next.connect(_task_children.bind(sibilings, index), CONNECT_ONE_SHOT)
	## Notify a user to execute the task
	task_started.emit()
	
	# TODO: remove these testing calls
	# tests cancellation in a chain
	if randf() < 0.01:
		task_cancel()
		return
	#tests cases where whole chain happens in one tick
	task_next()

## Internally used to mowe a flow through children tasks after user complete task
func _task_children(sibilings:Array[TaskSignalResource], index:int)->void:	
	if children_tasks.is_empty():
		_task_sibiling(sibilings, index)
		return
	
	var i:int = 0
	var task_runner:TaskSignalResource = children_tasks[i]
	task_runner.callback_complete.connect(_call_children_completed.bind(sibilings, index), CONNECT_ONE_SHOT )
	task_runner.task_start(children_tasks, i)

## Callback when children tasks has been completed
func _call_children_completed(_result:Result, _task_runner:TaskSignalResource, sibilings:Array[TaskSignalResource], index:int)->void:
	if result_from_child && (_result == Result.CANCEL || _result == Result.ERROR):
		task_complete.emit(_result, self)
		return
	_task_sibiling(sibilings, index)

## Internally used to flow through sibilings after all children has completed their tasks
func _task_sibiling(sibilings:Array[TaskSignalResource], index:int)->void:
	if index >= sibilings.size() -1:
		_call_complete()
		return
	
	var i:int = index + 1
	var task_runner:TaskSignalResource = sibilings[i]
	task_runner.callback_complete.connect(_call_sibilings_completed, CONNECT_ONE_SHOT )
	task_runner.task_start(sibilings, i)

## Callback when sibiling tasks has been completed
func _call_sibilings_completed(_result:Result, _task_runner:TaskSignalResource)->void:
	if result_from_next && (_result == Result.CANCEL || _result == Result.ERROR):
		task_complete.emit(_result, self)
		return
	_call_complete()

## Called after executing self, first children and next sibiling
func _call_complete()->void:
	if callback_complete.is_null():
		print("TaskSignalResource: ERROR - ", resource_name )
		callback_complete.emit(Result.ERROR, self)
		return
	
	print("TaskSignalResource: SUCCESS - ", resource_name )
	# create temporary copy to have cleared current calback when calling
	callback_complete.emit(Result.SUCCESS, self)
	


