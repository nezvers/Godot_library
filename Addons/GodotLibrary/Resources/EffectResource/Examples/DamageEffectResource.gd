class_name DamageEffectResource
extends EffectResource

## Emitted after processing. Sending EffectNode on which it was done.
## It migh be useful for synchronized ticking like visual effects or sound effects
signal tick(effect_node:Node)
signal resisted(effect_node:Node)

## HealthValueResource.value will be chacked by this ammount
@export var value:int = 1

@export var type:GameEnums.DamageType = GameEnums.DamageType.NONE

## Checks for resistance values
## TODO: include damage/resistance types
func effect_tick(effect_node:Node)->void:
	var _node:EffectNode2D = effect_node
	var resistance_list:Array[ResistanceValueResource]
	var health_list:Array[HealthValueResource]
	
	# collect list of needed types
	for value_resource in _node.value_resource_list:
		if value_resource is ResistanceValueResource:
			resistance_list.append(value_resource)
		elif value_resource is HealthValueResource:
			health_list.append(value_resource)
	
	var damage_value: = value
	for resistance in resistance_list:
		if resistance.type == type:
			damage_value -= resistance.value
	
	if damage_value > 0:
		for health in health_list:
			health.value -= damage_value
			play_sound()
#			print("damaged: ", health.value)
	else:
		resisted.emit(effect_node)
#		print("resisted")
		return
	
	tick.emit(effect_node)
