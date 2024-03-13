## Singleton script for managing scene changes.
extends Node

## List of room scene resource_path.
## Could be swapped for rooms per level
@export var game_scenes:AssetResource
## List of GUI scene resource_path
## Example: Title Gui, Store GUI, etc.
@export var gui_scenes:AssetResource
## List of globally "known" scene resource_path.
## Selected value used as first scene
## Example: Title room, store room, etc.
@export var global_scenes:AssetResource

## Length of past game scene history
@export var history_length:int = 10
## List of game scenes 
var history_scenes:AssetResource = AssetResource.new()

## Reference to a Node used to hold game scenes
@export var game_parent_reference:ReferenceNodeResource
## Reference to a Node used to hold GUI scenes
@export var gui_parent_reference:ReferenceNodeResource

var current_gui_key:String
## Common state resources for identifying scene state
enum {
	NEW_SCENE, # set by SceneManager after adding scene to the tree
	FADE_IN, 
	IDLE, 
	FADE_OUT, 
	FREE
}
var state_game_scene: = StateMachineResource.new()
var state_gui_scene: = StateMachineResource.new()

func _ready()->void:
	await get_tree().process_frame
	init_room()

func init_room()->void:
	game_scenes.load_resource()
	gui_scenes.load_resource()
	global_scenes.load_resource()
	
	set_global_room(global_scenes.selected)

func set_node(key:String, scene_list:AssetResource, parent:ReferenceNodeResource, state_resource:StateMachineResource, save_history:bool)->void:
	scene_list.load_resource()
	if parent == null:
		printerr("SceneManager: ERROR - scene LIST is NULL")
		return
	if parent.node == null:
		printerr("SceneManager: ERROR - scene list NODE is NULL: ", scene_list.resource_path.get_basename().get_file())
		return
	if !scene_list.dictionary.has(key):
		print("SceneManager: ERROR - scene list ", scene_list.resource_path.get_basename().get_file(), " doesn't has a room: ", key)
		return
	# Clear all possible rooms
	for node in parent.node.get_children():
		parent.node.remove_child(node)
		node.queue_free()
	state_resource.transition(FREE)
	# Retrieve room scene file
	var scene:PackedScene = scene_list.get_asset(key)
	if scene == null:
		printerr("SceneManager: ERROR - scene list ", scene_list.resource_path.get_basename(), " has INVALID room : ", key)
		return
	var scene_inst:Node = scene.instantiate()
	parent.node.add_child(scene_inst)
	state_resource.transition(NEW_SCENE)
	if state_resource.state != FADE_IN:
		state_resource.transition(IDLE)
	if save_history:
		return
	history_add(scene_list.dictionary[key])

func history_add(value:String)->void:
	history_scenes.list.push_front(value)
	if history_length == 0:
		return
	if history_scenes.list.size() > history_length:
		history_scenes.list.resize(history_length)

func set_game_room(key:String)->void:
	set_node(key, game_scenes, game_parent_reference, state_game_scene, true)

func set_global_room(key:String)->void:
	set_node(key, global_scenes, game_parent_reference, state_game_scene, true)

### Use key to instantiate a gui scene
func set_gui(key:String)->void:
	if current_gui_key == key:
		return
	current_gui_key = key
	set_node(key, gui_scenes, gui_parent_reference, state_gui_scene, false)


