extends Sprite2D
class_name ParallaxLayer2D

@export var speed:Vector2
@export var repeat:Vector2i
@export var sprite_offset:Vector2i : set = set_sprite_offset
@export var texture_size:Vector2
@export var debug:bool = false

var children_sprites: Array[Sprite2D]
var children2D:Array[Node2D]

func _ready()->void:
	if texture != null:
		texture_size = texture.get_size()
	var pp_can_process = get_parent().get_parent().can_process()
	if !pp_can_process:
		return
	if texture != null:
		return create_repeats()
	register_children()

func layer_position(pos:Vector2)->void:
	var lerp_pos:Vector2 = (pos * speed)
	
	lerp_pos.x = fmod(lerp_pos.x + texture_size.x, texture_size.x)
	lerp_pos.y = fmod(lerp_pos.y + texture_size.y, texture_size.y)
	global_position = (pos - lerp_pos).round()

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

func register_children()->void:
	for child in get_children():
		if child is Sprite2D:
			children_sprites.append(child)
		elif child is Node2D:
			children2D.append(child)

func set_sprite_offset(value:Vector2i)->void:
	sprite_offset = value
	offset = value
	for child in children_sprites:
		if child is Sprite2D:
			child.offset = offset
