extends Resource
class_name SharedResource

signal update

@export var resource:Resource : set = set_resource

var listeners:Array[Callable]

func set_resource(value:Resource)->void:
	resource = value
	update.emit()
	for callback in listeners:
		callback.call()

func listen(inst:Node, callback:Callable)->void:
	listeners.append(callback)
	callback.call()
	await inst.tree_exited
	listeners.erase(callback)

func get_save_file_path()->String:
	return "user://" + resource_name + ".tres"

func save_resource()->void:
	if ResourceSaver.save(resource, get_save_file_path()):
		print(resource_name, ": failed to save")

func load_resource()->void:
	if !FileAccess.file_exists(get_save_file_path()):
		print(resource_name, ": no savefile")
		return
	var data:SceneResource = ResourceLoader.load(get_save_file_path(), "SceneResource", ResourceLoader.CACHE_MODE_REPLACE)
	if data == null:
		print(resource_name, ": failed to load")
		return
	set_resource(data)

