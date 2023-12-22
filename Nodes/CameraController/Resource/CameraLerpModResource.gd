class_name CameraLerpModResource
extends CameraModResource

@export var lerp_strength:float = 1.0
#var projected_position:Vector2

func update(camera_controller:CameraController, target_position:Vector2, _projected_position:Vector2, delta:float)->Vector2:
#	projected_position = _projected_position.lerp(target_position, lerp_strength * delta)
	return _projected_position.lerp(target_position, lerp_strength * delta)

#func draw(camera_controller:CameraController, cam_pos:Vector2, projected_pos:Vector2)->void:
#	var local_pos:Vector2 = cam_pos - camera_controller.global_position
#	var target_pos:Vector2 = camera_controller.global_position - projected_position
#	camera_controller.draw_circle(local_pos + (target_pos * lerp_strength), 1.0, debug_color)
