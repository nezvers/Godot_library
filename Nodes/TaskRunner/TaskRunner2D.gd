extends Node2D
class_name TaskRunner2D

## Required for user to send notification when flow to next tasks
signal task_continue # for self awaiting


func start(sibilings:Array[Node], my_index)->void:
	await run_task()
	var children: = get_children()
	for i in children.size():
		await children[i].start(children, i)
	if my_index +1 >= sibilings.size():
		return
	await sibilings[my_index + 1].start(sibilings, my_index + 1)


func run_task()->void:
	# user sends notification when flow to next tasks
	await task_continue
