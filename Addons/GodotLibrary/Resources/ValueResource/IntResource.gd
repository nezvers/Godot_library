class_name IntResource
extends ValueResource

@export var value:int : set = set_value

func set_value(_value:int)->void:
	# TODO: interupt with validate or override (clamp)
	value = _value
	updated.emit()

