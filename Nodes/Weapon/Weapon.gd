extends Node2D

@export var input_resource:TopDown2DInputResource

func _process(_delta:float)->void:
	rotation = input_resource.aim_direction.angle()
