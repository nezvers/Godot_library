@tool
extends CanvasGroup
@export var color:Color : set = set_color
@export var time: = 0.5

var tween:Tween

func set_color(value:Color)->void:
	if material == null:
		return
	color = value
	material.set_shader_parameter("overlay", color)

func play()->void:
	if tween!= null && tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).bind_node(self)
# warning-ignore:return_value_discarded
	tween.tween_method(Interpolate ,1.0,0.0,time)

func Interpolate(t:float)->void:
	material.set_shader_parameter("blend", t)


