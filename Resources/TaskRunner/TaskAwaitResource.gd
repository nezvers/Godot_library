## Task chain resource executing self, then first child, then next sibiling
## Implemented using await and curently should be extended and overwriting run_task()
class_name TaskAwaitResource
extends Resource

## Required for user to send notification when flow to next tasks
signal task_next # for self awaiting

## Result of the task and options to handle errors
enum Result {
	SUCCESS, ## Returned if task it self is completed to the end
	CANCEL, ## Returned when a task is cancelled by task_cancel()
	ERROR, ## Returned when error is hit, like callback_complete isn't assigned
	}

## Child task array. Chain started with first entry
@export var child_tasks:Array[TaskAwaitResource]

##  Entry function. Needs to receive of sibiling TaskCallbackResources and index of a runner in that array
func task_start(sibilings:Array[TaskAwaitResource], my_index)->Result:
	var result:Result = await run_task()
	if result == Result.CANCEL || result == Result.ERROR:
		return result
	for i in child_tasks.size():
		result = await child_tasks[i].task_start(child_tasks, i)
		if result == Result.CANCEL || result == Result.ERROR:
			return result
	if my_index>= sibilings.size() - 1:
		return Result.SUCCESS
	result = await sibilings[my_index + 1].task_start(sibilings, my_index + 1)
	return result


func run_task()->Result:
	# user sends notification when flow to next tasks
	await task_next
	return Result.SUCCESS
