extends AnimationPlayer
#class_name AnimationController

@export var start_animation:StringName
@export var start_random_position:bool = false
@export var nextAnimation:String : set = set_next_animation

func _ready()->void:
	set_process(playback_process_mode == ANIMATION_PROCESS_MANUAL)
	if !start_animation.is_empty():
		play(start_animation)
	if start_random_position:
		var anim:Animation = get_animation(current_animation)
		seek(anim.length * randf())

func _process(delta:float)->void:
	advance(delta)

func set_next_animation(value:String)->void:
	if value.is_empty():
		return
	nextAnimation = value
	play(nextAnimation)

