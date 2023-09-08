class_name HealthValueResource
extends ValueResource

@export var value:int : set = set_value
@export var default_value:int
@export var min_value:int = 0
@export var max_value:int = 0

func set_value(_value:int)->void:
	var previous_value: = value
	value = clamp(_value, min_value, max_value)
	if previous_value == value:
		return
	updated.emit()

## Override function for resetting to default values
func reset_resource()->void:
	value = default_value

## Override for creating data Resource that will be saved with the ResourceSaver
func prepare_save()->Resource:
	return self.duplicate()

## Override to ad logic for reading loaded data and applying to current instance of the Resource
func prepare_load(_data:Resource)->void:
	value = _data.value
