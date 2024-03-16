## Resource for executing arbitrary task chains in tree like style
## Task returns callback with a result after executing self, first children and next sibiling
class_name TaskCallbackResource
extends Resource

## Signal to notify user when to respond to a task
signal task_started
## Signal to notify when TaskCallbackResource completed a task
signal task_complete

## Result of the task and options to handle errors
enum Result {
	SUCCESS, ## Returned if task it self is completed to the end
	CANCEL, ## Returned when a task is cancelled by task_cancel()
	ERROR, ## Returned when error is hit, like callback_complete isn't assigned
	}

## Child task array. Chain started with first entry
@export var children_tasks:Array[TaskCallbackResource]
## Child tasks can stop further chain with ERROR and CANCEL results
@export var result_from_child:bool = true
## Next sibiling task can stop further chain with ERROR and CANCEL results
@export var result_from_next:bool = true

## Important: root task must have callback_complete assigned
## gets called with (result:Result, task_runner:TaskCallbackResource = self)
var callback_complete:Callable = Callable()
## Holds bound values to send further when user calls task_next() 
var callback_next:Callable = Callable()
## If value is TRUE callback state is nulled on call execution.
## If value is FALSE callback state stays until next time of executing callback 
var reset_callbacks:bool = true

## User triggerable function to start transition to next task in the chain
func task_next()->void:
	if callback_next.is_null():
		printerr("TaskCallbackResource: ERROR - callback_next is not assigned")
		return
	callback_next.call()

## User triggerable function to cancel this task and return Result.CANCEL
func task_cancel()->void:
	print("TaskCallbackResource: CANCEL - ", resource_name)
	callback_next = Callable()
	callback_complete = callback_complete.bind(Result.CANCEL, self)
	var callback_temp: = callback_complete
	callback_complete = Callable()
	callback_temp.call()

##  Entry function. Needs to receive of sibiling TaskCallbackResources and index of a runner in that array
func task_start(sibilings:Array[TaskCallbackResource], index:int)->void:	
	# Bind sibiling and index
	callback_next = _task_children.bind(sibilings, index)
	## Notify a user to execute the bound task
	task_started.emit()

## Internally used to mowe a flow through children tasks after user complete task
func _task_children(sibilings:Array[TaskCallbackResource], index:int)->void:
	callback_next = Callable()
	
	if children_tasks.is_empty():
		_task_sibiling(sibilings, index)
		return
	
	var i:int = 0
	var task_runner:TaskCallbackResource = children_tasks[i]
	task_runner.callback_complete = _call_children_completed.bind(sibilings, index)
	task_runner.task_start(children_tasks, i)

## Callback when children tasks has been completed
func _call_children_completed(_result:Result, _task_runner:TaskCallbackResource, sibilings:Array[TaskCallbackResource], index:int)->void:
	if callback_complete == null:
		_call_error()
		return
	if result_from_child && (_result == Result.CANCEL || _result == Result.ERROR):
		callback_complete = callback_complete.bind(_result, self)
		var callback_temp: = callback_complete
		callback_complete = Callable()
		callback_temp.call()
		return
	_task_sibiling(sibilings, index)

## Internally used to flow through sibilings after all children has completed their tasks
func _task_sibiling(sibilings:Array[TaskCallbackResource], index:int)->void:
	if index >= sibilings.size() -1:
		_call_complete()
		return
	
	var i:int = index + 1
	var task_runner:TaskCallbackResource = sibilings[i]
	task_runner.callback_complete = _call_sibilings_completed
	task_runner.task_start(sibilings, i)

## Callback when sibiling tasks has been completed
func _call_sibilings_completed(_result:Result, _task_runner:TaskCallbackResource)->void:
	if result_from_next && (_result == Result.CANCEL || _result == Result.ERROR):
		callback_complete = callback_complete.bind(_result, self)
		var callback_temp: = callback_complete
		callback_complete = Callable()
		callback_temp.call()
		return
	_call_complete()

## Called after executing self, first children and next sibiling
func _call_complete()->void:
	# chains root must have a callback assigned
	assert(!callback_complete.is_null())
	
	print("TaskCallbackResource: SUCCESS - ", resource_name )
	# create temporary copy to have cleared current calback when calling
	callback_complete = callback_complete.bind(Result.SUCCESS, self)
	
	var callback_temp: = callback_complete
	callback_complete = Callable()
	callback_temp.call()

## Called when returns an error
func _call_error()->void:
	printerr("TaskCallbackResource: ERROR - ", resource_name )
	callback_complete = callback_complete.bind(Result.ERROR, self)
	var callback_temp: = callback_complete
	callback_complete = Callable()
	callback_temp.call()


static func test_single_tick_loop(count:int = 10, sibiling_count:int = 3, depth:int = 10)->void:
	print("---------------------------")
	print("TaskCallbackResource: TEST LOOP X", count)
	
	var _root:Array[TaskCallbackResource] = [TaskCallbackResource.new(),TaskCallbackResource.new(),TaskCallbackResource.new(),]
	var _0:Array[TaskCallbackResource] = [TaskCallbackResource.new(),TaskCallbackResource.new(),TaskCallbackResource.new(),]
	var _1:Array[TaskCallbackResource] = [TaskCallbackResource.new(),TaskCallbackResource.new(),TaskCallbackResource.new(),]
	var _2:Array[TaskCallbackResource] = [TaskCallbackResource.new(),TaskCallbackResource.new(),TaskCallbackResource.new(),]
	_root[0].children_tasks = _0
	_root[1].children_tasks = _1
	_root[2].children_tasks = _2
	# generate names
	for i in 3:
		_root[i].resource_name = str(i)
		_root[i].task_started.connect(_root[i].test_success)
		for j in 3:
			var inst:TaskCallbackResource = _root[i].children_tasks[j]
			inst.resource_name = str(i)+"_"+str(j)
			inst.task_started.connect(inst.test_success)
	
	_root[0].test_run(Result.SUCCESS, _root[0], _root, depth)

static func test_run(result:Result, task_runner:TaskCallbackResource, tasks:Array[TaskCallbackResource], i:int):
	if i == 0:
		return
	print(i, ": ___________________________")
	task_runner.callback_complete = TaskCallbackResource.test_run.bind(tasks, i-1)
	task_runner.task_start(tasks, 0)

func test_success()->void:
	# TODO: remove these testing calls
	# tests cancellation in a chain
	if randf() < 0.03:
		task_cancel()
		return
	if randf() < 0.03:
		_call_error()
		return
	#tests cases where whole chain happens in one tick
	task_next()

