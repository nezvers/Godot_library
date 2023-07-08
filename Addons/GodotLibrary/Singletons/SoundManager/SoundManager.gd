## Singleton script for managing SoundPlayers under it instead of instance objects.
extends Node

## During _ready will be created new SoundPlayers
@export var start_count:int = 10


var player_list:Array[SoundPlayer]


func _ready()->void:
	for i in start_count:
		var new_player: = SoundPlayer.new()
		add_child(new_player)
		player_list.append(new_player)

func get_player()->SoundPlayer:
	if player_list.is_empty():
		var new_player: = SoundPlayer.new()
		add_child(new_player)
		return new_player
	return player_list.pop_back()

func play(sound:SoundResource)->void:
	if sound.sound_player != null:
		sound.play(sound.sound_player)
		return
	var player: = get_player()
	player.finished.connect(return_player.bind(player,sound), CONNECT_ONE_SHOT)
	sound.play(player)

func return_player(player:SoundPlayer, sound:SoundResource)->void:
	sound.sound_player = null
	player_list.append(player)
