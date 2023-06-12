class_name ProjectileSpawnerTargeting2D
extends Node2D

@export var spawner:ProjectileSpawner2D
@export var target:ReferenceNodeResource

func aim_and_shoot()->void:
	if target.node == null:
		return
	spawner.direction = (target.node.global_position - global_position).normalized()
