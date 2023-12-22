extends ColorRect
class_name TransitionOverlay

signal completed

@export_range(0.0, 1.0) var progress:float = 0.0 : set = set_progress

func set_progress(value:float)->void:
	progress = value
	material.set_shader_parameter("progress", value)
