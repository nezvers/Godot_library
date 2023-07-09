## Resource to act as InputMap configuration.
class_name InputMapResource
extends Resource

@export var action_resource_list:Array[ActionEventResource]

var actions_dictionary:Dictionary

func init_actions()->void:
	for action in action_resource_list:
		action.add_action()
		actions_dictionary[action.resource_name] = action

func remove_actions()->void:
	actions_dictionary.clear()
	for action in action_resource_list:
		action.remove_action()

