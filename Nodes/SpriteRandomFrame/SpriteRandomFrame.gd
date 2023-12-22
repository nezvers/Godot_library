class_name SpriteRandomFrame
extends Node

@export var sprite:Sprite2D

func _ready()->void:
	sprite.frame = randi() % (sprite.hframes * sprite.vframes)
