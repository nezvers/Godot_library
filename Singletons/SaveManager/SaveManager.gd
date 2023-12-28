## Singleton script for controling save files within SceneTree
extends Node

## Resource holding game saveable data
@export var game_save_resource:SaveableResource
## Saves resources as separate save files and just loads at the start.
## Usable for settings or stuff that doesn't need to save/load each time with room changes.
@export var global_save_resources:Array[SaveableResource]

func _ready()->void:
	game_save_resource.load_resource()
	# Loads each global saveable
	for data in global_save_resources:
		data.load_resource()

