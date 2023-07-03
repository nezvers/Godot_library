class_name HealthValueResource
extends ValueResource

@export var value:int : set = set_value
@export var min_value:int = 0
@export var max_value:int = 0

func set_value(_value:int)->void:
	var previous_value: = value
	if max_value > 0:
		_value = min(_value, max_value)
	value = max(_value, min_value)
	if previous_value == value:
		return
	updated.emit()
