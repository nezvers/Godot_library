## Uses ScreenEffect singleton as parent for screen effects.
class_name ScreenEffectResource
extends Resource

## Signal with a reference to an instance before added as a child.
signal new_instance(inst:Node)

## Scene that will be instantiated under ScreenEffect singleton.
@export var screen_effect_scene:PackedScene

## Triggers spawning of the screen_effect_scene.
func play(position:Vector2 = Vector2.ZERO)->Node:
	assert(screen_effect_scene != null, resource_name + " doesn't contain a screen effect scene")
	var screen_effect_manager:Node = Engine.get_main_loop().root.get_node("ScreenEffect")
	if screen_effect_manager == null:
		print("ERROR: no ScreenEffect singleton detected")
		return
	
	if screen_effect_scene.is_class("Node2D"):
		var inst:Node2D = screen_effect_scene.instantiate()
		new_instance.emit(inst)
		inst.position = position
		screen_effect_manager.add_child(inst)
		return inst
	elif screen_effect_scene.is_class("Control"):
		var inst:Control = screen_effect_scene.instantiate()
		new_instance.emit(inst)
		inst.position = position
		screen_effect_manager.add_child(inst)
		return inst
	else:
		return null
