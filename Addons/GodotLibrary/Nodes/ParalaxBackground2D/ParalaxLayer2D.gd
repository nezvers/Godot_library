extends Sprite2D
class_name ParallaxLayer2D

@export var speed:Vector2
@export var repeat:Vector2i
@export var sprite_offset:Vector2i : set = set_sprite_offset
@export var texture_size:Vector2
@export var debug:bool = false

func _ready()->void:
	if texture == null:
		return
	texture_size = texture.get_size()
	create_repeats()

func layer_position(pos:Vector2)->void:
	var off:Vector2 = (pos * speed)
	off.x = fmod(off.x, texture_size.x)
	off.y = fmod(off.y, texture_size.y)
	global_position = (pos - off).round()
	if debug:
		print(global_position.x)

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
	#super.set_offset(value)
	for child in get_children():
		child.offset = offset
