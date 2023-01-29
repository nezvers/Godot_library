extends Resource
class_name SharedResource

signal update

@export var resource:Resource : set = set_resource

var listeners:Array[Callable]

func set_resource(value:Resource)->void:
	resource = value
	update.emit()
	for callback in listeners:
		callback.call()

func listen(inst:Node, callback:Callable)->void:
	listeners.append(callback)
	callback.call()
	await inst.tree_exited
	listeners.erase(callback)
