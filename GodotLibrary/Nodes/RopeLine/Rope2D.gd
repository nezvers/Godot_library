class_name Rope2D
extends Node2D

signal initialized

const IS_ANTIALIASED: bool = true
const FIRST_INDEX: int = 1
const NO_ROTATION_ANGLE: float = .0
const START_POSITION: Vector2 = Vector2.ZERO
const STATE_SMOOTH_FACTOR: float = .1

@export_range(1.0, 10.0) var width: float = 3.0
@export_range(3, 100) var segment_count: int = 50 : set = set_segment_count
@export_range(1.0, 100.0) var segment_length: float = 10.0
@export var split_index: int = 0 : set = set_split_index
@export_range(.0, .05) var top_stiffness: float = .001
@export_range(.0, 1.0) var stiffness: float = .5
@export_range(.0, .01) var frequency: float = .006
@export_range(0.0, 1.0) var amplitude: float = 0.0
@export_range(.0, 3.0) var max_amplitude: float = 1.15
@export var damping:float = 0.0
@export var direction:Vector2 = Vector2.DOWN
@export_color_no_alpha var color: Color = Color.YELLOW

var points: PackedVector2Array = []
var new_points: PackedVector2Array = []
var colors: PackedColorArray = []
var vertex_angles: PackedFloat32Array = []
var bottom_angles: PackedFloat32Array = []
var is_initialized: = false

func set_segment_count(value:int)->void:
	segment_count = max(2, value)
	set_split_index(split_index)

func set_split_index(value:int)->void:
	split_index = clamp(value, 0, max(segment_count - 1, 0))

func _ready()->void:
	init_rope()
	apply_new_points()
	apply_force(0.0)

func init_rope()->void:
	vertex_angles.clear()
	bottom_angles.clear()
	points.clear()
	
	for i in range(0, segment_count + 1):
		vertex_angles.append(.0)
		bottom_angles.append(.0)
		points.append(Vector2.ZERO)
	
	prepare_new_points()
	for i in new_points.size():
		points[i] = new_points[i]
	
	queue_redraw()
	is_initialized = true
	initialized.emit()

func apply_force(delta:float):
	# We can only specify fixed ranges in export_range, so let's make errors more friendly.
	
	amplitude = lerp(amplitude, 0.0, damping * delta)
	prepare_new_points()
	apply_new_points()
	

func prepare_new_points()->void:
	assert(split_index < segment_count, \
			"split_index must be lower than segment count.")
	
	new_points.clear()
	new_points.append(START_POSITION)
	vertex_angles[0] = NO_ROTATION_ANGLE
	bottom_angles[0] = vertex_angles[0]
	
	var bottom_start_index: int = FIRST_INDEX + split_index + 1
	var current_amplitude:float = max_amplitude * amplitude
	# above interaction
	for i in range(FIRST_INDEX, bottom_start_index):
		vertex_angles[i] = sin(Time.get_ticks_msec() * frequency) * current_amplitude
		new_points.append(new_points[i - 1] + direction.rotated(vertex_angles[i] * i * top_stiffness) * segment_length)
		bottom_angles[i] = vertex_angles[i]
	
	var remaining_points: int = vertex_angles.size() - bottom_start_index
	var shaping_step: float = 1.0 / max(remaining_points, 1)
	
	# below interaction
	for i in range(bottom_start_index, vertex_angles.size()):
		var point_amplitude:float = current_amplitude * i * top_stiffness
		var top_angle: float = sin(Time.get_ticks_msec() * frequency) * point_amplitude
		var lerp_step: float = 1.0 - shaping_step * (i - bottom_start_index)
		bottom_angles[i] = lerp(bottom_angles[i], bottom_angles[i - 1], stiffness)
		vertex_angles[i] = lerp(bottom_angles[i], top_angle, lerp_step)
		new_points.append(new_points[i - 1] + direction.rotated(vertex_angles[i]) * segment_length)

func apply_new_points()->void:
	for i in range(points.size()):
		points[i] = points[i].lerp(new_points[i], STATE_SMOOTH_FACTOR)
	
	for i in range(0, new_points.size()):
		colors.append(color)

func _process(delta:float)->void:
	apply_force(delta)
	queue_redraw()


func draw_rope()->void:
	draw_polyline_colors(points, colors, width, IS_ANTIALIASED)


func _draw()->void:
	draw_rope()
