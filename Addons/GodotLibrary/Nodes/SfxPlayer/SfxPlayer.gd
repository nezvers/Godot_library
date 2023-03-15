extends AudioStreamPlayer
class_name SfxPlayer

@export var retriggerTime: = 0.02
@export var randRange: = Vector2(0.8, 1.25)

func play_sfx()->void:
	if playing && get_playback_position() < retriggerTime:
		return
	pitch_scale = randf_range(randRange.x, randRange.y)
	play(0.0)
