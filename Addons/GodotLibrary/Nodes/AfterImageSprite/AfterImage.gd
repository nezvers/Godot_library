extends Node2D

@export var spriteScene:PackedScene

@export var targetPath:NodePath
@export var bodyPath:NodePath

@onready var targetSprite:Sprite2D = get_node(targetPath)
@onready var body:Node2D = get_node(bodyPath)

var tick:int = 0
var tick_inteval:int = 1

func _ready()->void:
	global_position = Vector2.ZERO
	set_physics_process(false)

func Spawn()->void:
	tick = (tick + 1) % tick_inteval
	if tick != 0:
		return
	
	var inst:Sprite2D = spriteScene.instantiate()
	inst.texture = targetSprite.texture
	inst.top_level = true
	inst.global_position = targetSprite.global_position
	inst.hframes = targetSprite.hframes
	inst.vframes = targetSprite.vframes
	inst.frame = targetSprite.frame
	inst.scale = body.scale
	owner.get_parent().add_child(inst)

func _physics_process(_delta:float)->void:
	Spawn()

func Start()->void:
	tick = -1
	Spawn()
	set_physics_process(true)

func Stop()->void:
	set_physics_process(false)

func _timeout():
	Spawn()
