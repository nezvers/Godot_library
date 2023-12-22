class_name CameraMouseModResource
extends CameraModResource

@export_range(0.0, 1.0) var lerp_strength:float = 1.0

func update(camera_controller:CameraController, target_position:Vector2, _projected_position:Vector2, delta:float)->Vector2:
	var mouse_pos:Vector2 = camera_controller.get_local_mouse_position()
	return lerp_strength * mouse_pos + target_position
