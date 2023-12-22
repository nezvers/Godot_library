extends Node2D

@export var lerp_speed: = Vector2(5, 3)
var deadzone_extent:Vector2 = Vector2(75, 150 )
@export var forward_strength: = Vector2(0, 30)

@export var limit_horizontal: = Vector2(-500, 500)
@export var limit_vertical: = Vector2(-20, 500)
@export var cameraReference:ReferenceNodeResource
@export var character:CharacterBody2D
var debug:bool = false


var difference: = Vector2.ZERO
var pos_delta: = Vector2.ZERO
var down_distance:float = 80.0
var down_t:float = 0.0
var owner_name:String
var projected_pos:Vector2
var target_pos:Vector2
var move_strength:float = 1.0
var move: = true

@onready var follow_target:Node2D = get_parent()

func _ready()->void:
	set_process(debug)
	if !can_process():
		return
	set_as_top_level(true)
	owner_name = owner.name
	global_position = follow_target.global_position
	projected_pos = global_position
	
	if cameraReference != null:
		cameraReference.listen(self, camera_reference_changed)
	else:
		set_physics_process(false)

func camera_reference_changed()->void:
	if cameraReference.node == null:
		set_physics_process(false)
		return
	set_physics_process(true)
	snap_position()

func snap_position()->void:
	projected_pos = follow_target.global_position
	target_pos = projected_pos
	global_position = projected_pos
	(cameraReference.node as Camera2D).global_position = global_position.round()

func _physics_process(delta:float)->void:
	difference = delta * forward_strength * character.velocity
	difference.y = look_down(delta)
	
	target_pos = follow_target.global_position + difference
#	var diff:Vector2 = (new_target_pos - target_pos)
#	var diff_abs:Vector2 = diff.abs()
#
#	if diff_abs.x > deadzone_extent.x || diff_abs.y > deadzone_extent.y:
#		target_pos += diff.sign() * (diff_abs - deadzone_extent)
	projected_pos = projected_pos.slerp(target_pos, delta * lerp_speed.x)
#	projected_pos.x = lerp(projected_pos.x, target_pos.x, delta * lerp_speed.x)
#	projected_pos.y = lerp(projected_pos.y, target_pos.y, delta * lerp_speed.y)
	projected_pos.x = clamp(projected_pos.x, follow_target.global_position.x 
										+ limit_horizontal.x, follow_target.global_position.x + limit_horizontal.y)
	projected_pos.y = clamp(projected_pos.y, follow_target.global_position.y 
										+ limit_vertical.x, follow_target.global_position.y + limit_vertical.y)
	global_position = projected_pos
	(cameraReference.node as Camera2D).global_position = global_position.round()

func _process(_delta:float)->void:
	queue_redraw()

func _draw()->void:
	if !debug:
		return
	var deadzone_rect: = Rect2(-deadzone_extent.x, -deadzone_extent.y, 2.0 * deadzone_extent.x, 2.0 * deadzone_extent.y)
	draw_rect(deadzone_rect, Color.WHITE, false)
	draw_circle(target_pos - global_position, 5.0, Color.YELLOW)
	draw_circle(projected_pos - global_position, 5.0, Color.RED)


func look_down(delta:float)->float:
	if owner.state.isGrounded && owner.buttons.axis.y > 0.75:
		if down_t < 1.0:
			down_t = min(down_t + delta, 1.0)
	else:
		down_t = max(down_t - delta, 0.0)
	return lerp(0.0, down_distance, (down_t) * (down_t))

#	queue_redraw()
#
#func _draw()->void:
#	draw_line(Vector2.ZERO, difference, Color.WHITE, 1)
