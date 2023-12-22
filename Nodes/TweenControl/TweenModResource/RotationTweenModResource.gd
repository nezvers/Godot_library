class_name RotationTweenModResource
extends TweenModResource

@export var from:float
@export var to:float

func play_tween(node:Node, current_value:float, target_value:float)->void:
	if node == null:
		return
	if tween_value_resource.value != null:
		tween_value_resource.value.kill()
	var tween:Tween = node.create_tween()
	tween_value_resource.value = tween
	
