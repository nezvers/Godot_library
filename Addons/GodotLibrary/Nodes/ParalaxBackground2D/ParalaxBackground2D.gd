extends Node2D
class_name ParalaxBackground2D

@export var cameraReference:ReferenceNodeResource

var layers:Array
var camera:Camera2D

func _ready()->void:
	global_position = Vector2.ZERO
	process_mode = Node.PROCESS_MODE_ALWAYS
	cameraReference.updated.connect(validate)
	for layer in get_children():
		if layer is ParallaxLayer2D:
			layers.append(layer)
#	for layer in layers:
#		layer.set_as_top_level(true)
	validate()

func validate()->void:
	if cameraReference.node == null:
		set_process(false)
	else:
		set_process(true)
		camera = cameraReference.node

func _process(_delta:float)->void:
	for layer in layers:
		layer.layer_position(camera.global_position)
