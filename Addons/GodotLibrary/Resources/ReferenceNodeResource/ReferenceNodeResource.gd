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
	if value == null:
		return
	value.tree_exited.connect(remove.bind(node), CONNECT_ONE_SHOT)

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
	inst.tree_exited.connect(erase_listener.bind(callback), CONNECT_ONE_SHOT)

func erase_listener(callback:Callable)->void:
	if listeners.has(callback):
		listeners.erase(callback)
