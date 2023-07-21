class_name CameraModResource
extends Resource

@export var debug_color:Color = Color.WHITE

func update(camera_controller:CameraController, target_position:Vector2, projected_position:Vector2, _delta:float)->Vector2:
	return Vector2.ZERO

func draw(camera_controller:CameraController, cam_pos:Vector2, projected_pos:Vector2)->void:
	pass
