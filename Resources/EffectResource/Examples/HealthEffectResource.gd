## Effect for health boost or cut
class_name HealthEffectResource
extends EffectResource

## Emitted after processing. Sending EffectNode on which it was done.
## It migh be useful for synchronized ticking like visual effects or sound effects
signal tick(effect_node:Node)

## HealthValueResource.value will be chacked by this ammount
@export var value:int = 1


## Adds value to HealthValueResource
func effect_tick(effect_node:Node)->void:
	var _node:EffectNode2D = effect_node
	print()
	# collect list of needed types
	for value_resource in _node.value_resource_list:
		if value_resource is HealthValueResource:
			value_resource.value += value
	
	tick.emit(effect_node)
