## 2D Top-Down character controller
class_name CharacterTopDown2D
extends CharacterBody2D

@export var input_resource:TopDown2DInputResource
@export var character_state:Character2DStateResource
@export var move_stats:Character2DMovementResource


func _physics_process(delta)->void:
	var move_direction:Vector2 = input_resource.move_direction
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	var target_velocity:Vector2 = move_direction * move_stats.move_speed
	var acceleration:float
	if move_direction.length() > 0.1:
		acceleration = move_stats.acceleration_ground
	else:
		acceleration = move_stats.stopping_ground
	character_state.velocity = character_state.velocity.lerp(target_velocity, acceleration * delta)
	
	if input_resource.dash:
		dash_input()
	
	velocity = character_state.velocity
	move_and_slide()
	character_state.velocity = velocity
#	print(move_direction)

## useful for dashing or kickback
func velocity_impulse(value:Vector2)->void:
	character_state.velocity += value

## Triggers dashing if cooldown allows it.
func dash_input()->void:
	if input_resource.move_direction.length() == 0.0:
		return
	var time: = Time.get_ticks_msec() * 0.001
	if character_state.dash_time + move_stats.dash_cooldown > time:
		return
	character_state.dash_time = time
	character_state.velocity = move_stats.dash_speed * input_resource.move_direction.normalized()
#	velocity_impulse(move_stats.dash_speed * input_resource.move_direction.normalized())


