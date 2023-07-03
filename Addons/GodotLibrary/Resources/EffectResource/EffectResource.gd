## Base class for applying an effect.
class_name EffectResource
extends Resource

## Effect ticks that will be triggered. At least 1 tick is guaranteed.
@export var tick_count:int = 0
## Time until next effect tick
@export var tick_time:float = 0.0
## Place to fill the description for an effect.
@export var description:String

## Assign EffectNode as target to apply an effect.
## - Do checks if needed EffectNode2D or EffectNode3D
## - effect_node.append_effect(self) if needed to be updated
## - Think if it needs to pass self.duplicate()
## - Considder assigning a Tween to EffectNode instead of a _process callback.
func apply(effect_node:Node, caster_node:Node = null)->void:
	effect_tick(effect_node)
	if tick_count -1 < 1:
		return
	var tween: = effect_node.create_tween()
	for i in tick_count:
		tween.tween_callback(effect_tick.bind(effect_node)).set_delay(tick_time * i)

## Dedicated place to use effect processing.
func effect_tick(effect_node:Node)->void:
	var _node:EffectNode2D = effect_node
	for value_resource in _node.value_resource_list:
		print(resource_name, ": ", value_resource)


## Called by EffectNode. It's a place to 
## - Count down a timer for ticks if needed
## - Interpolate an effect if needed
func _process(_effect_node:Node, _delta:float)->void:
	pass
