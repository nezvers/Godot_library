class_name ActionEventResource
extends Resource

@export var action:StringName
@export var event_array:Array[InputEvent]

func add_action()->void:
	if !InputMap.has_action(action):
		InputMap.add_action(action)
	for event in event_array:
		if !InputMap.action_has_event(action, event):
			InputMap.action_add_event(action, event)

func remove_action()->void:
	if !InputMap.has_action(action):
		return
	InputMap.erase_action(action)
