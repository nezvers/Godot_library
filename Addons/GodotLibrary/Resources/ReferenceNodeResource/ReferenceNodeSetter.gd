class_name ReferenceNodeSetter
extends Node

@export var reference_resource_path:String
@export var reference_node:Node
@export var process_only:bool = true
var reference_resource:ReferenceNodeResource

func _ready()->void:
	if process_only && !can_process():
		return
	if reference_resource_path.is_empty():
		return
	var parent: = get_parent()
	if !parent.is_node_ready():
		parent.ready.connect(set_reference_node, CONNECT_ONE_SHOT)
	else:
		set_reference_node()

func set_reference_node()->void:
	reference_resource = load(reference_resource_path)
	reference_resource.add( reference_node )
