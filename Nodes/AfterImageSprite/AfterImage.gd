extends Node2D

@export var spriteScene:PackedScene
@export var interval:float = 0.1

@export var targetPath:NodePath
@export var bodyPath:NodePath

@onready var timer: = $Timer
@onready var targetSprite:Sprite2D = get_node(targetPath)
@onready var body:Node2D = get_node(bodyPath)

func _ready()->void:
	timer.wait_time = interval
#	set_process(false)

func Spawn()->void:
	var inst:Sprite2D = spriteScene.instantiate()
	inst.texture = targetSprite.texture
	inst.global_position = targetSprite.global_position
	inst.hframes = targetSprite.hframes
	inst.vframes = targetSprite.vframes
	inst.frame = targetSprite.frame
	inst.scale = body.scale
	add_child(inst)

func _process(_delta:float)->void:
	global_position = Vector2.ZERO

func Start()->void:
	timer.start()
	Spawn()
#	set_process(true)

func Stop()->void:
	timer.stop()
#	set_process(false)

func _timeout():
	Spawn()
