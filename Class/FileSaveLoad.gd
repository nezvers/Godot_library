class_name FileSaveLoad
#static functions doesn't require to make an instance of the FileSaveLoad class

#    FileSaveLoad.save_config( "user://project/save.sav",  {volume = 100, resolution = Vector2(320, 180)} )
#    var saveData:Dictionary = FileSaveLoad.load_config( "user://project/save.sav" )


###### C O N F I G ######

static func save_config(path:String, data:Dictionary)->void:
	if !path.get_file().is_valid_filename():
		print("invalid file name")
		return
	
	var directory: = Directory.new()
	var dir: = path.get_base_dir() +"/"
	if !directory.dir_exists(dir):
# warning-ignore:return_value_discarded
		directory.make_dir_recursive(dir)
	
	#Save the file
	var config = ConfigFile.new()
	config.set_value("save_dictionary", "data_key", data)
	config.save(path)

static func load_config(path:String)->Dictionary:
	var config = ConfigFile.new()
	config.load(path)
	var data:Dictionary = config.get_value("save_dictionary", "data_key")
	return data


###### J S O N ### V O O R H E E S #########

#loading json requires saving variables with var2str() - config recommended
static func save_json(path:String, data:Dictionary)->void:
	if !path.get_file().is_valid_filename():
		print("invalid file name")
		return
	
	var directory: = Directory.new()
	var dir: = path.get_base_dir() +"/"
	if !directory.dir_exists(dir):
# warning-ignore:return_value_discarded
		directory.make_dir_recursive(dir)
	
	#Save the file
	var file: = File.new()
# warning-ignore:return_value_discarded
	file.open(path, File.WRITE)
	file.store_line(to_json(data))

static func load_json(path:String)->Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var data:Dictionary = parse_json(file.get_line())
	return data


###### R E S O U R C E ########

# best to save at user:/.... and extension .tres
static func save_resource(path:String, res:Resource)->void:
	if !path.get_file().is_valid_filename():
		print("invalid file name")
		return
	
	var directory: = Directory.new()
	var dir: = path.get_base_dir() +"/"
	if !directory.dir_exists(dir):
# warning-ignore:return_value_discarded
		directory.make_dir_recursive(dir)
	
	#Save the file
# warning-ignore:return_value_discarded
	ResourceSaver.save(path, res)

static func load_resource(path:String)->Resource:
	return ResourceLoader.load(path)
