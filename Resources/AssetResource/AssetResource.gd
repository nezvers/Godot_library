extends Resource
class_name AssetResource

signal updated
signal failed(error:String)

@export var list:Array[String]
@export var file_path:String
@export var asset_dir:String
@export var asset_extension:String

var dictionary:Dictionary
var is_initialized: = false

func get_asset(value:String)->PackedScene:
	if !dictionary.has(value):
		return null
	return load(dictionary.get(value))

func initialize(force:bool = false)->void:
	if is_initialized && !force:
		return
	dictionary.clear()
	for path in list:
		var key:String = path.get_file().get_basename()
		dictionary[key] = path
	is_initialized = true

func save_resource()->void:
	if file_path.is_empty():
		ResourceSaver.save(self, resource_path)
	else:
		DirAccess.make_dir_recursive_absolute(file_path.get_base_dir())
		ResourceSaver.save(self, file_path)

func load_resource(force:bool = false)->void:
	if is_initialized && !force:
		return
	var data:SceneResource
	if file_path.is_empty() && FileAccess.file_exists(resource_path):
		data = ResourceLoader.load(resource_path)
	elif FileAccess.file_exists(file_path):
		data = ResourceLoader.load(file_path)
	if data != null:
		list = data.list
	initialize(force)

func add_asset(value:String)->void:
	list.append(value)
	var key:String = value.get_file().get_basename()
	dictionary[key] = value
	save_resource()
	updated.emit()

func delete_asset(key:String)->void:
	if !dictionary.has(key):
		return
	var file_name:String = dictionary[key]
	DirAccess.remove_absolute(file_name)
	list.erase(dictionary[key])
	dictionary.erase(key)
	save_resource()
	updated.emit()

func save_asset(asset:Resource, asset_name:String)->void:
	var path: = process_path(asset_name)
	
	DirAccess.make_dir_recursive_absolute(asset_dir)
	asset.resource_path = path
	var err: = ResourceSaver.save(asset, asset.resource_path)
	if err:
		print("failed saving: ", path)
		return
	add_asset(asset.resource_path)

func process_path(asset_name:String)->String:
	var path:String = (asset_dir + asset_name + '.' + asset_extension).to_lower()
	if !FileAccess.file_exists(path):
		return path
	var i:int = 0
	while FileAccess.file_exists(path):
		path = (asset_dir + asset_name + '_' + str(i) + '.' + asset_extension).to_lower()
		i += 1
	return path
