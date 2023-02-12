extends Node2D

@export var lerpSpeed: = Vector2(5, 3)
@export var forward_strength: = Vector2(0, 30)

@export var limit_horizontal: = Vector2(-500, 500)
@export var limit_vertical: = Vector2(-20, 500)
@export var cameraReference:ReferenceNodeResource
@export var isEditorReference:ReferenceNodeResource
@onready var followTarget:Node2D = get_parent()

var prev_pos: = Vector2.ZERO
var difference: = Vector2.ZERO
var pos_delta: = Vector2.ZERO

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
	global_position = followTarget.global_position
	cameraReference.node.global_position = global_position
	prev_pos = global_position
	pos_delta = global_position

func _process(delta:float)->void:
	difference = forward_strength * (followTarget.global_position - prev_pos)
	prev_pos = followTarget.global_position
	global_position.x = lerp(global_position.x, followTarget.global_position.x + difference.x, delta * lerpSpeed.x)
	global_position.y = lerp(global_position.y, followTarget.global_position.y + difference.y, delta * lerpSpeed.y)
	global_position.x = clamp(global_position.x, followTarget.global_position.x + limit_horizontal.x, followTarget.global_position.x + limit_horizontal.y)
	global_position.y = clamp(global_position.y, followTarget.global_position.y + limit_vertical.x, followTarget.global_position.y + limit_vertical.y)
	
	(cameraReference.node as Camera2D).global_position = global_position.round()
#	queue_redraw()
#
#func _draw()->void:
#	draw_line(Vector2.ZERO, difference, Color.WHITE, 1)
