extends Resource
class_name SoundResource


@export var pitch_min:float = 1.0
@export var pitch_max:float = 1.0
@export_range(-80.0, +24.0) var volume:float = 0.0
@export var sound:AudioStream
@export var retrigger_time:float = 0.032

var last_play_time:float
var sound_player:SoundPlayer

func get_sound()->AudioStream:
	return sound

func get_pitch()->float:
	return randf_range(pitch_min, pitch_max)

func get_volume()->float:
	return volume

func play(_sound_player:SoundPlayer)->void:
	var time: = Time.get_ticks_msec() * 0.001
	if time < last_play_time + retrigger_time:
		return
	sound_player = _sound_player
	last_play_time = time
	sound_player.stream = get_sound()
	sound_player.pitch_scale = get_pitch()
	sound_player.volume_db = get_volume()
	sound_player.play()

func play_managed()->void:
	SoundManager.play(self)

