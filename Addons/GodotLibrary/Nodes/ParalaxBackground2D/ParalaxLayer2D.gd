extends Sprite2D
class_name ParallaxLayer2D

@export var speed:Vector2
@export var repeat:Vector2i
@export var sprite_offset:Vector2i : set = set_sprite_offset
@export var texture_size:Vector2

func _ready()->void:
	if texture != null:
		texture_size = texture.get_size()
	var pp_can_process = get_parent().get_parent().can_process()
	if !pp_can_process || texture == null:
		return
	create_repeats()

func layer_position(pos:Vector2)->void:
	var lPos:Vector2 = (pos * speed)
	lPos.x = fmod(lPos.x, texture_size.x)
	lPos.y = fmod(lPos.y, texture_size.y)
	global_position = (pos - lPos).round()

func create_repeats()->void:
	if texture == null:
		return
	for x in range(-repeat.x, repeat.x +1):
		for y in range(-repeat.y, repeat.y +1):
			var inst:Sprite2D = Sprite2D.new()
			add_child(inst)
			inst.position = texture_size * Vector2(x, y)
			inst.texture = texture
			inst.offset = offset
	texture = null

func set_sprite_offset(value:Vector2i)->void:
	sprite_offset = value
	offset = value
	for child in get_children():
		child.offset = offset
