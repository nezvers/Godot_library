## Provide EffectResource ability to have over time effect.
class_name EffectNode2D
extends Node2D

## Effects that are repeatedly called in _process
## Effects in ready are removed from list and applied by default
@export var effect_resource_list:Array[EffectResource]
## ValueResources added by default
@export var value_resource_list:Array[ValueResource]

# TODO: maybe optimize with pre-sized array and use effect type enums as access index

func _ready()->void:
	var initial_effects:Array[EffectResource] = effect_resource_list
	effect_resource_list = []
	for effect in initial_effects:
		effect.apply(self)
	set_process(!effect_resource_list.is_empty())

## Add effect to the list to be called each _process
func append_effect(effect:EffectResource)->void:
	if !effect_resource_list.has(effect):
		effect_resource_list.append(effect)
	set_process(!effect_resource_list.is_empty())

## Remove an effect from processing list.
func remove_effect(effect:EffectResource)->void:
	if effect_resource_list.has(effect):
		effect_resource_list.erase(effect)
	set_process(!effect_resource_list.is_empty())

## Add a ValueResource to a list
func append_value_resource(value:ValueResource)->void:
	if !value_resource_list.has(value):
		value_resource_list.append(value)

## Removed value from a list
func remove_value_resource(value:ValueResource)->void:
	if value_resource_list.has(value):
		value_resource_list.erase(value)

## Call _process on each effect
func _process(delta:float)->void:
	for effect in effect_resource_list:
		# TODO: effect tick
		effect._process(self, delta)

