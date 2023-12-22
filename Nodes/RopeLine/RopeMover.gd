class_name RopeMover
extends Node

@export var speed:float
@export var rope_split:bool
@export var rope_follower:Node
@export var rope:Node
@export var enabled:bool = true : set = set_enabled

var speed_scale:float = 0.0
var direction:int = 1

func set_enabled(value:bool)->void:
	enabled = value
	set_process(enabled)

func set_speed(value:float)->void:
	speed = value
	if rope_follower == null:
		return
	var segment_count = rope_follower.bottom_bound - rope_follower.top_bound
	var length:float = segment_count * rope.segment_length
	speed_scale = speed/length

func _ready()->void:
	set_process(false)
	
	await get_tree().process_frame
	var segment_count = rope_follower.bottom_bound - rope_follower.top_bound
	var length:float = segment_count * rope.segment_length
	speed_scale = speed/length
	set_enabled(enabled)

func _process(delta:float)->void:
	var value:float = rope_follower.position_blend + delta * speed_scale * direction
	rope_follower.position_blend = clamp(value, 0.0, 1.0)
	
	set_rope_split()
	if value >= 1.0:
		direction = -1
	elif value <= 0.0:
		direction = 1

func set_rope_split()->void:
	if !rope_split:
		return
	rope.split_index = rope_follower.point_index

