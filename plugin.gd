@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("SoundManager", "res://addons/Godot_library/Singletons/SoundManager/Scenes/SoundManager.tscn")
	#AudioServer.set_bus_layout(load("res://addons/Godot_library/Singletons/SoundManager/Resources/AudioBussLayout.tres"))


func _exit_tree():
	remove_autoload_singleton("SoundManager")
