## Singleton script for controling save files within SceneTree
extends Node

## Resource holding game saveable data
@export var game_save_resource:SaveableResource

@export var global_save_resources:Array[SaveableResource]

func _ready()->void:
	game_save_resource.load_resource()
	
	for data in global_save_resources:
		data.load_resource()

