
#-----UNTESTED-----#

extends KinematicBody
class_name RigidKinematicBody3D

signal collided

export(Vector3) var linear_velocity = Vector3.ZERO
export(Vector3) var gravity = Vector3(0, 20) setget set_gravity
export(float) var dampening = 0.005 #if too low value it starts gain speed when rolling on the ground
export(float, 0.0, 1.0) var bounciness = 0.5

var collision:KinematicCollision
var remainder: = Vector3.ZERO

func set_gravity(value:Vector3)->void:
	gravity = value

func set_linear_velocity(value:Vector3)->void:
	linear_velocity = value

func _physics_process(delta:float)->void:
	rigid_physics(delta)

func rigid_physics(delta:float)->void:
	linear_velocity += gravity #add gravity
	collision = move_and_collide(linear_velocity * delta + remainder) #apply physics
	linear_velocity = linear_velocity * (1 - dampening) #reduce speed over time
	if collision: #collision detected
		var normal:Vector3 = collision.normal #surface normal
		var strenght:float = -normal.dot(linear_velocity) #
		linear_velocity += normal * strenght * (1 - bounciness) #dampen velocity in floor direction
		linear_velocity = linear_velocity.bounce(normal) #bounce off the surface
		remainder = collision.remainder.bounce(normal) #add in next frame
		collision_callback(collision, strenght)
	else:
		remainder = Vector3.ZERO #No collision means no remainder

func apply_impulse(value:Vector3)->void:
	linear_velocity += value

func collision_callback(_collision:KinematicCollision, _strength:float)->void:	#use this function to read collision
	emit_signal("collided", collision, strenght)					#by default it emits collision
