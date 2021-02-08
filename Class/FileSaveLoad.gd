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
	var err:int = config.save(path)
	if err:
		print("couldn't save: ", err)

static func load_config(path:String)->Dictionary:
	var directory: = Directory.new()
	if !directory.file_exists(path):
		return {}
	
	var config = ConfigFile.new()
	config.load(path)
	var data:Dictionary = config.get_value("save_dictionary", "data_key")
	return data


###### J S O N ### V O O R H E E S #########

#Dictionary is converted to string with var2str() on saving
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
	file.store_line(to_json(var2str(data)))

#Dictionary is converted from string with str2var() on loading
static func load_json(path:String)->Dictionary:
	var directory: = Directory.new()
	if !directory.file_exists(path):
		return {}
	
	var file = File.new()
	file.open(path, File.READ)
	var data:Dictionary = str2var(parse_json(file.get_line()))
	file.close()
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
	var err: = ResourceSaver.save(path, res)
	if err:
		print("couldn't save: ", err)

static func load_resource(path:String)->Resource:
	return ResourceLoader.load(path)


###### S T R I N G #########

static func save_text(path:String, text:String)->void:
	if !path.get_file().is_valid_filename():
		print("invalid file name")
		return
	
	var directory: = Directory.new()
	var dir: = path.get_base_dir() +"/"
	if !directory.dir_exists(dir):
# warning-ignore:return_value_discarded
		directory.make_dir_recursive(dir)
	
	#Save the file
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(text)
	file.close()

static func load_text(path:String)->String:
    var directory: = Directory.new()
	if !directory.file_exists(path):
		return ""
    
    var file: = File.new()
    file.open(path, File.READ)
    var text: = file.get_as_text()
    file.close()
    return text


###### G O T M ###########
# requires Gotm.gd as autoload

static func gotm_save_png(img:Image, fileName:String)->void:
	var gotmFile: = GotmFile.new()
	gotmFile.name = fileName
	gotmFile.data = img.save_png_to_buffer()
	gotmFile.download()

static func gotm_save_text(text:String, fileName:String)->void:
	var gotmFile: = GotmFile.new()
	gotmFile.name = fileName
	gotmFile.data = text.to_utf8()
	gotmFile.download()

static func gotm_save_data(data:Dictionary, fileName:String)->void:
    var gotmFile: = GotmFile.new()
	gotmFile.name = fileName
	gotmFile.data = var2str(data).to_utf8()
	gotmFile.download()

# load functions must be triggered through user interaction (button).
# call function through yield - var data:Dictionary = yield(gotm_load_data(['.sav']))
static func gotm_load_data(extensions:Array = ['.txt'])->Dictionary:
    var file = yield(Gotm.pick_files(extensions, true), "completed")[0]
	var data:Dictionary = str2var(file.data.get_string_from_utf8())
    return data

static func gotm_load_png()->Image:
    var file = yield(Gotm.pick_files(['.png'], true), "completed")[0]
    var img: = Image.new()
    img.load_png_from_buffer(file.data)
    return img

