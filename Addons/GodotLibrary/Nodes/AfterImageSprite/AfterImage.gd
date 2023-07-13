extends Node2D

## Sprite scene that will be instantiated
@export var sprite_scene:PackedScene
## Sprite that will be copied
@export var target_sprite_node:Sprite2D
## Node used for sprite flipping
@export var flip_node:Node2D

var tick:int = 0
var tick_inteval:int = 1

func _ready()->void:
	global_position = Vector2.ZERO
	set_physics_process(false)

func spawn()->void:
	tick = (tick + 1) % tick_inteval
	if tick != 0:
		return
	
	var inst:Sprite2D = sprite_scene.instantiate()
	inst.texture = target_sprite_node.texture
	inst.top_level = true
	inst.global_position = target_sprite_node.global_position
	inst.hframes = target_sprite_node.hframes
	inst.vframes = target_sprite_node.vframes
	inst.frame = target_sprite_node.frame
	inst.scale = flip_node.scale
	owner.get_parent().add_child(inst)

func _physics_process(_delta:float)->void:
	spawn()

func start()->void:
	tick = -1
	spawn()
	set_physics_process(true)

func stop()->void:
	set_physics_process(false)

func _timeout():
	spawn()
