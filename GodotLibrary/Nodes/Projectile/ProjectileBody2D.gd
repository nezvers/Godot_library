extends CharacterBody2D

signal collision_impact

## Initial direction
@export var direction:Vector2 = Vector2.RIGHT
## Initial speed in the direction
@export var speed:float = 300.0

## Visual rotation
@export var rotate_direction:bool = true
## Horizontal flip instead of rotating past 180 degrees
@export var flip_direction:bool = true
## Designated node for flipping horizontally
@export var flip_node:Node2D
## Designated node for rotation. Preferably child of `flip_node`
@export var rotate_node:Node2D
## PackedScene for spawning muzzle effect.
@export var muzzle_scene:PackedScene
## PackedScene for spawning impact effect.
@export var impact_scene:PackedScene
## PackedScene for spawning timeout effect.
@export var timeout_scene:PackedScene
## Vector applied to the velocity. Useful for direction al pull like gravity.
@export var acceleration:Vector2 = Vector2.ZERO
@export var debug:bool = false

## counts down how many bounces left
var bounce_count:int = 0

func _ready()->void:
	velocity = speed * direction
	direction_rotation()
	spawn_vfx(muzzle_scene)

## Logic for handling vfx PackedScenes
func spawn_vfx(scene:PackedScene)->void:
	if scene == null:
		return
	var parent: = get_parent()
	var inst:Node2D = scene.instantiate()
	inst.global_position = global_position
	inst.scale = scale
	inst.rotation = rotation
	parent.add_child.call_deferred(inst)

func _physics_process(delta:float)->void:
	velocity += acceleration * delta
	var collision: = move_and_collide(velocity * delta)
		
	if !collision:
		return
	if bounce_count < 1:
		impact()
		return
	bounce_count -= 1
	direction = direction.bounce(collision.get_normal())
	direction_rotation()

## Applies visual rotation
func direction_rotation()->void:
	if flip_direction:
		if rotate_direction:
			rotate_node.rotation = Vector2(abs(direction.x), direction.y).angle()
		flip_node.scale.x = sign(direction.x)
	elif rotate_direction:
		rotate_node.rotation = Vector2(direction).angle()

## Function to apply impulse to the velocity
func impulse(value:Vector2)->void:
	velocity += value

## Trigger function for impact
func impact()->void:
	collision_impact.emit()
	spawn_vfx(impact_scene)
	queue_free()

## Trigger function for timeout
func timeout():
	spawn_vfx(timeout_scene)
	queue_free()
