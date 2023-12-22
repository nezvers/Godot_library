## Resource for preconfigured spawning to be triggered from anywhere.
class_name SpawnResource
extends Resource

## Sends a reference to a new instance before it's added as a child
signal new_instance(node:Node)

## Reference resource to a node that will be used as parent node.
@export var parent_node_reference:ReferenceNodeResource
## Scene that will be instantiated and added as child.
@export var packed_scene:PackedScene

## Spawns an instance of a packed_scene
func spawn()->Node:
	if parent_node_reference.node == null:
		return
	var instance:Node = packed_scene.instantiate()
	new_instance.emit(instance)
	parent_node_reference.node.add_child(instance)
	return instance
