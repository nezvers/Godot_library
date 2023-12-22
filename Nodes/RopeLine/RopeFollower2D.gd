class_name RopeFollower2D
extends Node2D

const QUARTER: float = -PI * .5

@export var rope:Rope2D
@export var top_bound: int = 0
@export var bottom_bound: int = 0
@export var update:bool
@export_range(0.0, 1.0) var position_blend:float = 0.0 : set = set_position_blend

var point_index:int = 0
var point_next_index:int = 0
var point_index_lerp:float = 0.0
var point_blend:float = 0.0

func set_top_bound(value:int)->void:
	top_bound = clamp(value, 0, rope.points.size())

func set_bottom_bound(value:int)->void:
	bottom_bound = clamp(max(value, top_bound + 1), 0, rope.points.size())

func set_position_blend(value:float)->void:
	position_blend = value
	if rope == null:
		return
	if !rope.is_initialized:
		return
	point_index_lerp = lerp(float(top_bound), float(bottom_bound - 1), position_blend)
	point_index = int(floor(point_index_lerp))
	point_next_index = min(point_index + 1, bottom_bound)
	point_blend = point_index_lerp - point_index
	apply_rotation()
	apply_position()

func set_update(value:bool)->void:
	update = value
	set_process(update)

func _ready()->void:
	if !rope.is_initialized:
		await rope.initialized
	set_top_bound(top_bound)
	set_bottom_bound(bottom_bound)
	set_position_blend(position_blend)
	set_process(update)

func _process(_delta:float)->void:
	apply_rotation()
	apply_position()

func apply_rotation():
	var point_from:Vector2 = rope.points[point_index]
	var point_to:Vector2 = rope.points[point_next_index]
	rotation = point_from.angle_to_point(point_to)
	if point_index != point_next_index:
		rotation += QUARTER


func apply_position():
	var point_pos:Vector2 = rope.points[point_index].lerp(rope.points[point_next_index], point_blend)
	global_position = rope.global_position + point_pos
