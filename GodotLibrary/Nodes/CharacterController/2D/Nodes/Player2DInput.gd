extends Node2D

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
	tree_exiting.connect(input_map_resource.remove_actions, CONNECT_ONE_SHOT)


func _process(_delta:float)->void:
	# Move
	input_resource.move_direction.x = Input.get_action_strength(right) - Input.get_action_strength(left)
	input_resource.move_direction.y = Input.get_action_strength(down) - Input.get_action_strength(up)
	input_resource.dash = Input.is_action_pressed(dash)
	# Aim
	# TODO: support for joystick
	input_resource.aim_direction = get_local_mouse_position().normalized()

