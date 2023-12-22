## Singleton to expose functionality to resources
extends Node2D

@export var main_camera_reference:ReferenceNodeResource

func get_current_camera()->Node:
	return get_viewport().get_camera_2d()

