@tool
extends CanvasGroup
@export var color:Color = Color(1.0, 1.0, 1.0, 0.05) : set = set_color
@export var time: = 0.5
@export var flash_material:Material
var tween:Tween

func set_color(value:Color)->void:
	if Engine.is_editor_hint() && material != flash_material:
		material = flash_material
		return
	if material == null:
		return
	color = value
	material.set_shader_parameter("overlay", color)

func _ready()->void:
	if Engine.is_editor_hint() || !can_process():
		return
	material = flash_material.duplicate()
	set_color(color)

func play()->void:
	if tween!= null && tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).bind_node(self)
# warning-ignore:return_value_discarded
	tween.tween_method(Interpolate ,1.0,0.0,time)

func Interpolate(t:float)->void:
	if material == null:
		return
	material.set_shader_parameter("blend", t)


