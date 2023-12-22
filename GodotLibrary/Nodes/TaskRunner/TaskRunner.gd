extends Node
class_name TaskRunner

signal task_continue # for self awaiting


func start(sibilings:Array[Node], my_index)->void:
	await run_task()
	var children: = get_children()
	for i in children.size():
		await children[i].start(children, i)
	if my_index == sibilings.size() - 1:
		return
	await sibilings[my_index + 1]


func run_task()->void:
	await task_continue
