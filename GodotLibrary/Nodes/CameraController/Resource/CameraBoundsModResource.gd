class_name CameraBoundsModResource
extends CameraModResource

@export var rect:Rect2

func update(camera_controller:CameraController, target_position:Vector2, projected_position:Vector2, _delta:float)->Vector2:
	if projected_position.x < target_position.x + rect.position.x:
		projected_position.x = target_position.x + rect.position.x
	elif projected_position.x > target_position.x + rect.position.x + rect.size.x:
		projected_position.x = target_position.x + rect.position.x + rect.size.x
	
	if projected_position.y < target_position.y + rect.position.y:
		projected_position.y = target_position.y + rect.position.y
	elif projected_position.y > target_position.y + rect.position.y + rect.size.y:
		projected_position.y = target_position.y + rect.position.y + rect.size.y
	
	return projected_position


func draw(camera_controller:CameraController, cam_pos:Vector2, projected_pos:Vector2)->void:
	var local_pos:Vector2 = cam_pos - camera_controller.global_position
	var _rect: = rect
	_rect.position += local_pos
	camera_controller.draw_rect(_rect, debug_color, false)
