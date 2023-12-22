extends Node

var callbacks: Dictionary
var paths:Array[String]

func _ready()->void:
	set_process(false)

func state_check()->void:
	set_process(!paths.is_empty())

func _process(_delta:float)->void:
	for path in paths:
		var status: = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			load_done(path)
		elif status != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			load_failed(path)

func load_start(path:String, callable:Callable)->void:
	if ResourceLoader.load_threaded_request(path, "PackedScene", false, ResourceLoader.CACHE_MODE_REUSE):
		print("SceneLoader: start load failed")
		return
	paths.append(path)
	callbacks[path] = callable
	state_check()

func load_done(path:String)->void:
	var scene:PackedScene = ResourceLoader.load_threaded_get(path)
	callbacks[path].call(scene)
	paths.erase(path)
	callbacks.erase(path)
	state_check()

func load_failed(path:String)->void:
	callbacks[path].call(null)
	paths.erase(path)
	callbacks.erase(path)
	print("SceneLoader: Load failed - ", path)
	state_check()

