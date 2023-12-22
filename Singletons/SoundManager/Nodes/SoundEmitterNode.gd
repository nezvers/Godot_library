class_name SoundEmitterNode
extends Node

@export var sound:SoundResource

func play()->void:
	sound.play_managed()
