extends Node2D
class_name Drawer

static func draw_ring(node:CanvasItem, radius:float, resolution:int, radian_from:float, color:Color, width:float)->void:
	var increments: float = 2*PI / resolution
	var rad: = radian_from
	var to: = Vector2.ZERO
	var from: = Vector2(cos(rad)*radius, sin(rad)*radius)
	for i in resolution:
		rad = radian_from + increments * (i+1)
		to = Vector2(cos(rad)*radius, sin(rad)*radius)
		node.draw_line(from, to, color, width)
		from = to
