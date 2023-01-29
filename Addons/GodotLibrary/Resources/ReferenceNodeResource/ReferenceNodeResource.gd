extends Resource
class_name ReferenceNodeResource

signal updated

var node:Node
var listeners:Array[Callable]

func add(value:Node)->void:
	node = value
	updated.emit()
	for callback in listeners:
		callback.call()
	await value.tree_exited
	remove(value)

func remove(value:Node)->void:
	if node != value:
		return
	node = null
	updated.emit()
	for callback in listeners:
		callback.call()

func listen(inst:Node, callback:Callable)->void:
	listeners.append(callback)
	callback.call()
	await inst.tree_exited
	listeners.erase(callback)
