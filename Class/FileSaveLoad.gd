class_name FileSaveLoad
#static functions doesn't require to make an instance of the FileSaveLoad class


###### J S O N # V O O R H E E S #########

static func save_json(path:String, data:Dictionary)->void:
    if !path.get_file().is_valid_filename():
		print("invalid file name")
		return 1
    
    #chech if directory exists. If not then create it
    var directory: = Directory.new()
    var baseDir: = path.get_base_dir()
    if !directory.dir_exists(baseDir):
        directory.make_dir_recursive(baseDir)
    
    #Save the file
    var file: = File.new()
    file.open(path, File.WRITE)
    file.store_line(to_json(data))

static func load_json(path:String)->Dictionary:
    #check if file exists
    var directory: = Directory.new()
    if !directory.file_exists(path)
        print("File doesn't exist")
        
    #Read the json file
    var file = File.new()
    file.open(SAVE_PATH, File.READ)
    var data:Dictionary = parse_json(file.get_line())
    return data


###### C O N F I G ######

static func save_config(path:String, data:Dictionary)->void:
    if !path.get_file().is_valid_filename():
		print("invalid file name")
		return 1
    
    #chech if directory exists. If not then create it
    var directory: = Directory.new()
    var baseDir: = path.get_base_dir()
    if !directory.dir_exists(baseDir):
        directory.make_dir_recursive(baseDir)
    
    #Save the file
    var config = ConfigFile.new()
    config.set_value("save_dictionary", "data_key", data)
    config.save(path)

static func load_config(path:String)->Dictionary:
    #check if file exists
    var directory: = Directory.new()
    if !directory.file_exists(path)
        print("File doesn't exist")
        
    #Read the config file
    var config = ConfigFile.new()
    config.load(path)
    var data:Dictionary = config.get_value("save_dictionary", "data_key")
    return data


###### R E S O U R C E ########

# best to save at user:/.... and extension .tres
static func save_resource(path:String, res:Resource)->void:
    if !path.get_file().is_valid_filename():
		print("invalid file name")
		return 1
    
    #chech if directory exists. If not then create it
    var directory: = Directory.new()
    var baseDir: = path.get_base_dir()
    if !directory.dir_exists(baseDir):
        directory.make_dir_recursive(baseDir)
    
    #Save the file
    ResourceSaver.save(path, res)

static func load_resource(path:String)->Resource:
    #check if file exists
    var directory: = Directory.new()
    if !directory.file_exists(path)
        print("File doesn't exist")
        
    #Read the config file
    return ResourceLoader.load(path)
