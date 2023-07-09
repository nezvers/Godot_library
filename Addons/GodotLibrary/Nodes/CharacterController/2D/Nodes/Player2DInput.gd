extends Node

@export_group("Resources")
@export var input_resource:TopDown2DInputResource
@export var input_map_resource:InputMapResource
@export_group("Action Names")
@export var right:StringName
@export var left:StringName
@export var down:StringName
@export var up:StringName
@export var dash:StringName

func _ready()->void:
	input_map_resource.init_actions()
	await tree_exiting
	input_map_resource.remove_actions()


func _process(_delta:float)->void:
	input_resource.move_direction.x = Input.get_action_strength(right) - Input.get_action_strength(left)
	input_resource.move_direction.y = Input.get_action_strength(down) - Input.get_action_strength(up)
	input_resource.dash = Input.is_action_pressed(dash)
	

