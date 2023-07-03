class_name DictionaryResource
extends ValueResource

@export var value:Dictionary : set = set_value

func set_value(_value:Dictionary)->void:
	value = _value
	updated.emit()
