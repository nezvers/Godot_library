extends Resource
class_name AssetResource

enum PathMode{
	WAIT,
	OVERWRITE,
	INDEX,
	CANCEL,
}

signal updated
signal failed(error:String)
signal filename_exists # awaits path processing
signal path_process_choice(value:PathMode)

@export var list:Array[String]
@export var selected:String : set = set_selected
@export var file_path:String
@export var asset_dir:String
@export var asset_extension:String

var dictionary:Dictionary
var is_initialized: = false

func set_selected(value:String)->void:
	if selected == value:
		return
	selected = value

func get_asset(key:String)->Resource:
	if !dictionary.has(key):
		return null
	var path: String = dictionary.get(key)
	if path == null:
		print("AssetResource: Something wrong")
		return
	var asset:Resource = load(path)
	if asset == null:
		print("AssetResource: failed load: ", path)
	return asset

func initialize(force:bool = false)->void:
	if is_initialized && !force:
		return
	dictionary.clear()
	for path in list:
		var key:String = path.get_file().get_basename()
		dictionary[key] = path
	is_initialized = true

func save_resource()->void:
	if resource_path.is_empty():
		return
	if file_path.is_empty():
		ResourceSaver.save(self, resource_path)
	else:
		DirAccess.make_dir_recursive_absolute(file_path.get_base_dir())
		ResourceSaver.save(self, file_path)

func load_resource(force:bool = false)->void:
	if is_initialized && !force:
		return
	var data:AssetResource
	if file_path.is_empty() && FileAccess.file_exists(resource_path):
		data = ResourceLoader.load(resource_path)
	elif FileAccess.file_exists(file_path):
		data = ResourceLoader.load(file_path)
	if data != null:
		list = data.list
	initialize(force)

func add_asset(value:String)->void:
	var key:String = value.get_file().get_basename()
	if dictionary.has(key):
		return
	list.append(value)
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

func clear_assets()->void:
	for key in dictionary.keys():
		var file_name:String = dictionary[key]
		DirAccess.remove_absolute(file_name)
	list.clear()
	dictionary.clear()

func save_asset(asset:Resource, asset_name:String, mode:PathMode = PathMode.INDEX)->void:
	if asset == null:
		failed.emit("No asset to save")
		return
	if asset_name.is_empty():
		failed.emit("no asset name to save")
		return
	
	var path:String = await process_path(asset_name, mode)
	if path.is_empty():
		return
	
	var err = DirAccess.make_dir_recursive_absolute(asset_dir)
	if err:
		failed.emit("Failed make a directory")
		return
	asset.resource_path = path
	err = ResourceSaver.save(asset, asset.resource_path)
	if err:
		failed.emit("failed saving: " + path)
		return
	add_asset(asset.resource_path)

func process_path(asset_name:String, mode:PathMode)->String:
	#asset_name = asset_name.to_lower()
	var path:String = (asset_dir + asset_name + '.' + asset_extension)
	if !FileAccess.file_exists(path):
		return path
	
	if mode == PathMode.WAIT:
		filename_exists.emit()
		mode = await path_process_choice
	
	if mode == PathMode.CANCEL:
		failed.emit("Path already exists")
		return ""
	elif mode == PathMode.OVERWRITE:
		return path
	
	# TODO: handle already indexed filenames
	var i:int = 0
	while FileAccess.file_exists(path):
		path = (asset_dir + asset_name + '_' + str(i) + '.' + asset_extension)
		i += 1
	return path
