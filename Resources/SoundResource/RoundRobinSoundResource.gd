extends SoundResource
class_name SoundListResource

@export var sound_list:Array[AudioStream]
enum ListStyle {ROUND_ROBIN, RANDOM}
@export var list_style:ListStyle

var index:int = 0

func get_sound()->AudioStream:
	sound = sound_list[index]
	if list_style == ListStyle.ROUND_ROBIN:
		index = (index + 1) % sound_list.size()
	else:
		index = randi() % sound_list.size()
	return super.get_sound()
