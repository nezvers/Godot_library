extends Node2D

@export var lerpSpeed: = 5.0
@export var limit_horizontal: = Vector2(-100, 100)
@export var limit_vertical: = Vector2(-100, 100)
@export var cameraReference:ReferenceNodeResource
@export var isEditorReference:ReferenceNodeResource
@export var followTarget:Node2D

func _ready()->void:
	if isEditorReference.node != null:
		return
	set_as_top_level(true)
	global_position = followTarget.global_position
	cameraReference.listen(self,check_camera)

func check_camera()->void:
	if cameraReference.node == null:
		set_process(false)
		return
	set_process(true)
	cameraReference.node.global_position = global_position

func _process(delta:float)->void:
	global_position = lerp (global_position, followTarget.global_position, delta * lerpSpeed)
	global_position.x = clamp(global_position.x, followTarget.global_position.x + limit_horizontal.x, followTarget.global_position.x + limit_horizontal.y)
	global_position.y = clamp(global_position.y, followTarget.global_position.y + limit_vertical.x, followTarget.global_position.y + limit_vertical.y)
	
	(cameraReference.node as Camera2D).global_position = global_position
