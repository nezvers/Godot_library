extends Resource
class_name SoundResource

@export var pitch_min:float = 1.0
@export var pitch_max:float = 1.0
@export_range(-80.0, +24.0) var volume:float = 0.0
@export var sound:AudioStream
@export var retrigger_time:float = 0.032
@export var pitch_cooldown:float
@export var pitch_return:float
@export var pitch_add:float = 0.0

var last_play_time:float
var audio_stream_player:SoundPlayer
var delta:float
var sound_player:SoundPlayer
var pitch:float

func get_sound()->AudioStream:
	return sound

func get_pitch()->float:
	if delta < pitch_cooldown:
		pitch = pitch + pitch_add
		return pitch
	elif delta < pitch_cooldown + pitch_return:
		var mid_pitch:float = lerp(pitch_min, pitch_max, 0.5)
		var t:float = (delta - pitch_cooldown) / pitch_return
		pitch = lerp(pitch, mid_pitch, t)
	else:
		pitch = randf_range(pitch_min, pitch_max)
	return pitch

func get_volume()->float:
	return volume

func play(_sound_player:SoundPlayer)->void:
	var time: = Time.get_ticks_msec() * 0.001
	if time < last_play_time + retrigger_time:
		return
	delta = time - last_play_time
	sound_player = _sound_player
	last_play_time = time
	sound_player.stream = get_sound()
	sound_player.pitch_scale = get_pitch()
	sound_player.volume_db = get_volume()
	sound_player.play()

## Tries to call SoundManager singleton for it to deal with life time of sound playing node.
func play_managed()->void:
	var sound_manager:Node = Engine.get_main_loop().root.get_node("SoundManager")
	if sound_manager == null:
		print("ERROR: no SoundManager singleton detected")
		return
	sound_manager.play(self)
	#SoundManager.play(self)
