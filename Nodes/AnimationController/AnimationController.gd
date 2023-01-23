extends AnimationPlayer
#class_name AnimationController

@export var nextAnimation:String

func _ready()->void:
	set_process(playback_process_mode == ANIMATION_PROCESS_MANUAL)

func SwitchTo()->void:
	play(nextAnimation)

func _process(delta:float)->void:
	advance(delta)
