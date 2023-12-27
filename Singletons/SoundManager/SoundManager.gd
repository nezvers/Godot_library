## Singleton script for managing SoundPlayers under it instead of instance objects.
extends Node

## During _ready will be created new SoundPlayers
@export var start_count:int = 10
@export var bus_name:String = "Sounds"
@export var audio_settings:AudioSettingsResource

var player_list:Array[SoundPlayer]

## Make sure Sounds audio bus exists and create initial sound players
func _ready()->void:
	for i in start_count:
		create_player()

## Pops out one sound player 
func get_player()->SoundPlayer:
	if player_list.is_empty():
		create_player()
	return player_list.pop_back()

func create_player()->SoundPlayer:
	var new_player: = SoundPlayer.new()
	new_player.bus = bus_name
	add_child(new_player)
	player_list.append(new_player)
	return new_player

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
