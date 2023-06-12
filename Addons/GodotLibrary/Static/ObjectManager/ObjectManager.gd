class_name ObjectManager
extends Node


static func clone_properties(from:Object, into:Object, property_usage_flags:int = 4102)->void:
	var property_list:Array[Dictionary] = from.get_property_list()
	for property in property_list:
		# be mindfull with Array, Dictionary contents are the same
		# possible to create reference loop
		if int(property.usage) != property_usage_flags:
			continue
		#print(property.name, ", ", property.usage)
		into.set(property.name, from.get(property.name))

