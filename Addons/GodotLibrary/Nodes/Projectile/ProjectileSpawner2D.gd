class_name ProjectileSpawner2D
extends Node2D

@export var projectile_scene:PackedScene
@export var parent_reference:SpawnReference
@export var angles:Array[float] = [0.0]
@export var direction:Vector2 = Vector2.RIGHT
@export var lock_x:bool = false
@export var debug:bool = false

func spawn()->void:
	if parent_reference.parent == null:
		return
	if lock_x:
		direction = global_transform.x
	direction = direction.normalized()
	
	for angle in angles:
		var dir: = direction.rotated(deg_to_rad(angle))
		var inst:Node2D = projectile_scene.instantiate()
		inst.direction = dir
		inst.global_position = global_position
		parent_reference.parent.add_child(inst)
