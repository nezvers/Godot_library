## Base class to create saveable Resource
class_name SaveableResource
extends Resource

signal resource_saved
signal resource_loaded

@export var version:String

## Override function for resetting to default values
func reset_resource()->void:
	pass

## Override for creating data Resource that will be saved with the ResourceSaver
func prepare_save()->Resource:
	return self.duplicate()

## Override to ad logic for reading loaded data and applying to current instance of the Resource
func prepare_load(_data:Resource)->void:
	pass

func get_save_file_path()->String:
	return "user://" + resource_name + ".tres"

func save_resource()->void:
	if ResourceSaver.save(prepare_save(), get_save_file_path()):
		print(resource_name, ": failed to save")
		return
	resource_saved.emit()

func load_resource()->void:
	if !FileAccess.file_exists(get_save_file_path()):
		print(resource_name, ": no savefile")
		return
	var data:Resource = ResourceLoader.load(get_save_file_path())
	if data == null:
		print(resource_name, ": Save file didn't load")
		return
	
	prepare_load(data)
	resource_loaded.emit()

func delete_resource()->void:
	if !FileAccess.file_exists(get_save_file_path()):
		pass
	DirAccess.remove_absolute(get_save_file_path())
