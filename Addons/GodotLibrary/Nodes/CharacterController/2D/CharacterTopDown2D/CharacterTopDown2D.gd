## 2D Top-Down character controller
class_name CharacterTopDown2D
extends CharacterBody2D

@export var input_resource:TopDown2DInputResource
@export var character_state:Character2DStateResource
@export var move_stats:Character2DMovementResource


func _physics_process(delta)->void:
	var target_velocity:Vector2 = input_resource.move_direction * move_stats.move_speed
	var acceleration:float
	if input_resource.move_direction.length() > 0.1:
		acceleration = move_stats.acceleration_ground
	else:
		acceleration = move_stats.stopping_ground
	character_state.velocity = character_state.velocity.lerp(target_velocity, acceleration * delta)
	
	velocity = character_state.velocity
	move_and_slide()
	character_state.velocity = velocity
#	print(input_resource.move_direction)

## useful for dashing or kickback
func velocity_impulse(value:Vector2)->void:
	character_state.velocity += value

## Trigger dashing if cooldown allows it.
func dash()->void:
	if input_resource.move_direction.length() == 0.0:
		return
	var time: = Time.get_ticks_msec() * 0.001
	if character_state.dash_time + move_stats.dash_cooldown > time:
		return
	character_state.dash_time = time
	velocity_impulse(move_stats.dash_speed * input_resource.move_direction.normalized())


