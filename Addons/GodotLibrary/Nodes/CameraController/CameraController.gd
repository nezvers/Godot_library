## Node for camera controlling
class_name CameraController
extends Node2D

@export var camera_reference:ReferenceNodeResource
@export var mod_list:Array[CameraModResource]
@export var debug:bool = false

var projected_position:Vector2

func _ready()->void:
	set_process(false)
	camera_reference.listen(self, camera_changed)

func camera_changed()->void:
	if camera_reference.node != null:
		projected_position = camera_reference.node.global_position
	set_process(camera_reference.node != null)

func _process(delta:float)->void:
	var new_projection: = projected_position
	for camera_mod in mod_list:
		new_projection = camera_mod.update(global_position, new_projection, delta)
	projected_position = new_projection
	camera_reference.node.global_position = projected_position.round()
	
	if debug:
		queue_redraw()

func _draw()->void:
	if !debug:
		return
	
	for camera_mod in mod_list:
		camera_mod.draw(self, camera_reference.node.global_position, projected_position)
