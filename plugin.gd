@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("SoundManager", "res://addons/Godot_library/Singletons/SoundManager/Scenes/SoundManager.tscn")
	add_autoload_singleton("SceneManager", "res://addons/Godot_library/Singletons/SceneManager/Scenes/SceneManager.tscn")
	add_autoload_singleton("SaveManager", "res://addons/Godot_library/Singletons/SaveManager/Scenes/SaveManager.tscn")
	#AudioServer.set_bus_layout(load("res://addons/Godot_library/Singletons/SoundManager/Resources/AudioBussLayout.tres"))


func _exit_tree():
	remove_autoload_singleton("SoundManager")
	remove_autoload_singleton("SceneManager")
	remove_autoload_singleton("SaveManager")
