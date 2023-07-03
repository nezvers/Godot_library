class_name FloatResource
extends ValueResource

@export var value:float : set = set_value

func set_value(_value:float)->void:
	value = _value
	updated.emit()
