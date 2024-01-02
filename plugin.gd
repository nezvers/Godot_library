@tool
extends EditorPlugin

## Workaround to be able to create directories and save scenes
class Setup:
	extends Node
	var editor_plugin:EditorPlugin
	func _init(_plugin:EditorPlugin)->void:
		editor_plugin = _plugin
	
	func _ready()->void:
		if !DirAccess.dir_exists_absolute("res://autoload/"):
			DirAccess.make_dir_recursive_absolute("res://autoload/")
		
		var target_path:String = "res://autoload/SaveManager.tscn"
		if !FileAccess.file_exists(target_path):
			print("SaveManager DOESN'T EXIST: ", target_path)
			var save_manager_scene:PackedScene = preload("res://addons/Godot_library/Singletons/SaveManager/Scenes/SaveManager.tscn")
			ResourceSaver.save(save_manager_scene, target_path)
		editor_plugin.add_autoload_singleton("SaveManager", target_path)
		
		target_path = "res://autoload/SceneManager.tscn"
		if !FileAccess.file_exists(target_path):
			print("SceneManager DOESN'T EXIST: ", target_path)
			var scene_manager_scene:PackedScene = preload("res://addons/Godot_library/Singletons/SceneManager/Scenes/SceneManager.tscn")
			ResourceSaver.save(scene_manager_scene, target_path)
		editor_plugin.add_autoload_singleton("SceneManager", target_path)
		
		target_path = "res://autoload/SoundManager.tscn"
		if !FileAccess.file_exists(target_path):
			print("SoundManager DOESN'T EXIST: ", target_path)
			var sound_manager_scene:PackedScene = preload("res://addons/Godot_library/Singletons/SoundManager/Scenes/SoundManager.tscn")
			ResourceSaver.save(sound_manager_scene, target_path)
		editor_plugin.add_autoload_singleton("SoundManager", target_path)
		
		queue_free()

func _enter_tree():
	var setup: = Setup.new(self)
	var base_control: = EditorInterface.get_base_control()
	base_control.add_child(setup)
	
	# TODO: Audio buss layoutt assign doesn't work
	#AudioServer.set_bus_layout(load("res://autoload/SoundManager.tscn"))


func _exit_tree():
	remove_autoload_singleton("SoundManager")
	remove_autoload_singleton("SceneManager")
	remove_autoload_singleton("SaveManager")
