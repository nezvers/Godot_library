class_name ArrayResource
extends Resource

signal update

@export var value:Array
@export var default_value:Array

func append(entry)->void:
	value.append(entry)
	update.emit()

## Override function for resetting to default values
func reset_resource()->void:
	value = default_value

## Override for creating data Resource that will be saved with the ResourceSaver
func prepare_save()->Resource:
	return self.duplicate()

## Override to ad logic for reading loaded data and applying to current instance of the Resource
func prepare_load(_data:Resource)->void:
	value = _data.value
