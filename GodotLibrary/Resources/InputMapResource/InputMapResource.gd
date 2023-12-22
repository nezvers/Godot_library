## Resource to act as InputMap configuration.
class_name InputMapResource
extends Resource

## List of actions
@export var action_resource_list:Array[ActionEventResource]

## Additional way to acces needed action. Action resource_name is used as a key.
var actions_dictionary:Dictionary

## Adds actions to the InputMap
func init_actions()->void:
	for action in action_resource_list:
		action.add_action()
		actions_dictionary[action.resource_name] = action

## Remove all actions from InputMap
func remove_actions()->void:
	actions_dictionary.clear()
	for action in action_resource_list:
		action.remove_action()

