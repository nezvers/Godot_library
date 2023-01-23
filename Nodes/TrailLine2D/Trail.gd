extends Line2D

@export var length:int = 5
@export var targetPosPath:NodePath

@onready var target:Node2D = get_node(targetPosPath)


func _ready()->void:
	clear_points()

func _process(_delta:float)->void:
	global_position = Vector2.ZERO
	
	add_point(target.global_position)
	if get_point_count() > length:
		remove_point(0)
