class_name MenuTraverseManager
extends Node

## String : NodePath
## Menu hierchy represented as node path and binds node with a NodePath
@export var menu_path:Dictionary
## Dictionary key reserved for nodes in a directory
@export var node_key:String = "_node_"

## Use a dedicated resource for this task
var directory_resource:DictionaryDirectoryResource = DictionaryDirectoryResource.new()
## Keep in memory to know about previous directory
var current_directory:Dictionary

func _ready()->void:
	## Populate nodes in their directories
	for key in menu_path.keys():
		var path: = NodePath(key)
		var node:Node = get_node(menu_path[key])
		node.visible = false
		directory_resource.add_item(path, node, node_key)
	directory_resource.selected_directory_changed.connect(directory_changed)
	#current_directory = directory_resource.directory_get_current()
	directory_changed()

## Hide previous node and show new
func directory_changed()->void:
	var node:Node = directory_get_node()
	if node != null:
		node.visible = false
	current_directory = directory_resource.directory_get_current()
	node = directory_get_node()
	if node != null:
		node.visible = true

## Retrieve node from a directory. If key doesn't exist, returns null.
func directory_get_node()->Node:
	if !current_directory.has(node_key):
		return null
	return current_directory[node_key]

## Sends method call to directory_resource
func open(value:String)->void:
	directory_resource.directory_open(value)

## Sends method call to directory_resource
func back()->void:
	directory_resource.directory_back()

