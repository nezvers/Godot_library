extends AudioStreamPlayer
class_name SoundPlayer

@export var sound_resource:SoundResource


func play_sound()->void:
	if sound_resource == null:
		print(owner.name, ": ", name, " doesn't have sound")
		return
	sound_resource.play(self)
