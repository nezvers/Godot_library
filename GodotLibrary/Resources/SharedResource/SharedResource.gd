## Resource to reference the same Resource and send notification signal when reference is changed
class_name SharedResource
extends SaveableResource

## Signal to notify about changes
signal update

## Reference to a Resource
@export var resource:Resource : set = set_resource

## List of callback functions
var listeners:Array[Callable]

## Setter function
func set_resource(value:Resource)->void:
	resource = value
	update.emit()
	for callback in listeners:
		callback.call()

## Called to subscribe for changes
func listen(inst:Node, callback:Callable)->void:
	listeners.append(callback)
	callback.call()
	inst.tree_exited.connect(remove_callback.bind(callback), CONNECT_ONE_SHOT)

## Unsubscribe from updates
func remove_callback(callback:Callable)->void:
	listeners.erase(callback)


func prepare_load(data:Resource)->void:
	set_resource(data)

