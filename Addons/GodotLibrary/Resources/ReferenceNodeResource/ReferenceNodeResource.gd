## Resource to reference the same Node and receive notification when the reference is changed.
class_name ReferenceNodeResource
extends Resource

## Notification signal when reference has been changed
signal updated

## Referenced node shared between resource holders
var node:Node

## Callback list for change listeners
var listeners:Array[Callable]

## Sets referenced node
func set_reference(value:Node)->void:
	node = value
	updated.emit()
	for callback in listeners:
		callback.call()
	if value == null:
		return
	value.tree_exited.connect(remove_reference.bind(node), CONNECT_ONE_SHOT)

func remove_reference(value:Node)->void:
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
