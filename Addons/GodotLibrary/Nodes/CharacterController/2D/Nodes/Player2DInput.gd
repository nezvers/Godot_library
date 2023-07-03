extends Node2D

@export var input_resource:TopDown2DInputResource
@export var right:ActionEventResource
@export var left:ActionEventResource
@export var down:ActionEventResource
@export var up:ActionEventResource

func _ready()->void:
	right.add_action()
	left.add_action()
	down.add_action()
	up.add_action()
	await tree_exiting
	right.remove_action()
	left.remove_action()
	down.remove_action()
	up.remove_action()


func _process(_delta:float)->void:
	input_resource.move_direction.x = Input.get_action_strength(right.action) - Input.get_action_strength(left.action)
	input_resource.move_direction.y = Input.get_action_strength(down.action) - Input.get_action_strength(up.action)
	if input_resource.move_direction.length() > 1.0:
		input_resource.move_direction = input_resource.move_direction.normalized()

