## Screen Shake resource
class_name ScreenShakeResource
extends Resource

## Reference to the same tween in case one is already playing.
@export var tween_value_resource:TweenValueResource
## Tween duration
@export var tween_duration:float = 0.5
## Curve for frequency change over shake's lifetime
@export var frequency:Curve
## Curve for shake amplitude change over shake's lifetime
@export var amplitude:Curve
## Value for random angle range
@export_range (0.0, 360.0) var angle_from:float = 0.0
## Value for random angle range
@export_range (0.0, 360.0) var angle_to:float = 360.0
## Screen shake vibration direction
var direction:Vector2

## Plays screen shake on camera assigned to reference resource.
func play()->void:
	var camera:Camera2D = CameraManager.get_current_camera()
	if camera == null:
		return
	
	var angle = deg_to_rad(lerp(angle_from, angle_to, randf())) * PI * 2
	direction = Vector2(cos(angle), sin(angle))
	
	var tween:Tween = tween_value_resource.value
	
	if tween != null:
		tween.kill()
	
	tween = camera.create_tween().bind_node(camera)
	tween.tween_method(sample.bind(camera), 0.0, 1.0, tween_duration)

## Samples screen shake offset from frequency and amplitude curves.
func sample(t:float, camera:Camera2D)->void:
	if camera == null:
		return
#	assert(t >= 0.0 && t <= 1.0, "Sampling argument is out of range")
	var offset:Vector2 = sin(PI * 2 * frequency.sample(t) * tween_duration * (1.0 - t)) * amplitude.sample(t) * direction
	camera.offset = offset

