## Uses ScreenEffect singleton as parent for screen effects.
class_name ScreenEffectResource
extends Resource

@export var screen_effect_scene:PackedScene

func play(position:Vector2 = Vector2.ZERO)->Node:
	assert(screen_effect_scene != null, resource_name + " doesn't contain a screen effect scene")
	if screen_effect_scene.is_class("Node2D"):
		var inst:Node2D = screen_effect_scene.instantiate()
		inst.position = position
		ScreenEffect.add_child(inst)
		return inst
	elif screen_effect_scene.is_class("Control"):
		var inst:Control = screen_effect_scene.instantiate()
		inst.position = position
		ScreenEffect.add_child(inst)
		return inst
	else:
		return null
