extends TileMap
class_name TileCursor

@export var dragEvent:InputEvent
@export var drawEvent:InputEvent
@export var eraseEvent:InputEvent
@export var cameraReference:ReferenceNodeResource

var tileMap:TileMap
var tileSize:Vector2i
var terrain_index:int = 0
var terrain_set_index:int = 0
var id_index:int = 0
var cursorPos: = Vector2i(-999,-999)
var in_front:bool = true
var dragging: = false
var drawing: = false
var erasing: = false
var drag_from:Vector2i

@onready var target_position:Vector2 = get_global_mouse_position()
@onready var mouse_pos:Vector2 = get_global_mouse_position()
var draw_action:StringName = "TileCursor_draw"
var drag_action:StringName = "TileCursor_drag"
var erase_action:StringName = "TileCursor_erase"

func _ready()->void:
	var parent:Node = get_parent()
	if !(parent is TileMap):
		set_process_unhandled_input(false)
		print("TileCursor parent isn't TileMap")
		return
	tileMap = parent
	change_tileset(tile_set)
	register_actions()

func register_actions()->void:
	InputMap.add_action(drag_action)
	InputMap.action_add_event(drag_action, dragEvent)
	InputMap.add_action(draw_action)
	InputMap.action_add_event(draw_action, drawEvent)
	InputMap.add_action(erase_action)
	InputMap.action_add_event(erase_action, eraseEvent)

func _exit_tree()->void:
	InputMap.erase_action(drag_action)
	InputMap.erase_action(draw_action)
	InputMap.erase_action(erase_action)

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseMotion:
		var mp: = get_global_mouse_position()
		process_position(mp - mouse_pos)
		mouse_pos = mp
	elif event.is_action_pressed(draw_action):
		drawing = true
		if !dragging:
			tileMap.set_cells_terrain_connect(terrain_index, [cursorPos], terrain_set_index, terrain_index)
		else:
			drag_from = cursorPos
	elif event.is_action_pressed(erase_action):
		erasing = true
		if !dragging:
			tileMap.set_cells_terrain_connect(terrain_index, [cursorPos], terrain_set_index, -1)
		else:
			drag_from = cursorPos
	elif event.is_action_pressed(drag_action):
		dragging = true
		drag_from = cursorPos
	elif event.is_action_released(drag_action):
		dragging = false
		queue_redraw()
	elif event.is_action_released(draw_action):
		drawing = false
		queue_redraw()
		if dragging:
			set_tile_region(terrain_index)
	elif event.is_action_released(erase_action):
		erasing = false
		queue_redraw()
		if dragging:
			set_tile_region(-1)
	elif event.is_action_released("menu_next"):
		var i:int = (terrain_index + 1) % tile_set.get_terrains_count(0)
		set_terrain_index(i)
	elif event.is_action_released("menu_previous"):
		var i:int = (terrain_index + tile_set.get_terrains_count(0) - 1) % tile_set.get_terrains_count(0)
		set_terrain_index(i)

func process_position(velocity:Vector2)->void:
	target_position += velocity
	var tilePos: = tileMap.local_to_map(target_position)
	if cursorPos == tilePos:
		return
	cursorPos = tilePos
	position = cursorPos * tileSize
	check_visibility()
	if !drawing && !erasing:
		return
	if dragging:
		queue_redraw()
	elif drawing:
		tileMap.set_cells_terrain_connect(terrain_index, [cursorPos], terrain_set_index, terrain_index)
	elif erasing:
		tileMap.set_cells_terrain_connect(terrain_index, [cursorPos], terrain_set_index, -1)

func change_tileset(tileset:TileSet)->void:
	tile_set = tileset
	tileMap.tile_set = tileset
	tileSize = tile_set.tile_size
	# make layers
	for i in get_layers_count():
		if tileMap.get_layers_count() < i +1:
			tileMap.add_layer(i)
		tileMap.set_layer_z_index(i, get_layer_z_index(i))

func set_terrain_index(i:int)->void:
	terrain_index = i
	check_visibility()
	if in_front:
		set_cells_terrain_connect(0, [Vector2i.ZERO], terrain_set_index, terrain_index)
	else:
		set_cells_terrain_connect(0, [Vector2i.ZERO], terrain_set_index, -1)

func set_in_front(value:bool)->void:
	if in_front == value:
		return
	in_front = value
	if in_front:
		set_cells_terrain_connect(0, [Vector2i.ZERO], terrain_set_index, terrain_index)
	else:
		set_cells_terrain_connect(0, [Vector2i.ZERO], terrain_set_index, -1)
	queue_redraw()

func check_visibility()->void:
	for i in get_layers_count():
		var tileData: = tileMap.get_cell_tile_data(i, cursorPos)
		if tileData == null:
			continue
		var tmz: = tileMap.get_layer_z_index(i)
		var lz: = get_layer_z_index(terrain_index)
		var z: = tmz - lz
		if z < 1:
			continue
		set_in_front(false)
		return
	set_in_front(true)

func set_tile_region(region_terrain_index:int)->void:
	var from: = Vector2i(min(drag_from.x, cursorPos.x), min(drag_from.y, cursorPos.y))
	var to: = Vector2i(max(drag_from.x, cursorPos.x), max(drag_from.y, cursorPos.y))
	var size: = Vector2i(max(to.x - from.x + 1, 1), max(to.y - from.y + 1, 1))
	var pos_array: Array[Vector2i] = []
	for x in size.x:
		for y in size.y:
			pos_array.append(Vector2i(from.x + x, from.y + y))
	tileMap.set_cells_terrain_connect(terrain_index, pos_array, terrain_set_index, region_terrain_index)

func _draw()->void:
	if !in_front:
		var rect: = Rect2(Vector2.ZERO, tileSize)
		var line_thickness:float = 1.0 / min(cameraReference.node.zoom.x, 1.0)
		draw_rect(rect, modulate, false, line_thickness)
	
	if !(!dragging || !drawing && !erasing):
		var line_thickness:float = 1.0 / min(cameraReference.node.zoom.x, 1.0)
		var from: = Vector2i(min(drag_from.x, cursorPos.x), min(drag_from.y, cursorPos.y))
		var to: = Vector2i(max(drag_from.x, cursorPos.x), max(drag_from.y, cursorPos.y))
		var pos:Vector2 = (from * tileSize)
		pos -= position
		var size: = Vector2(max(to.x - from.x + 1, 1) * tileSize.x, max(to.y - from.y + 1, 1) * tileSize.y)
		var rect: = Rect2(pos, size)
		draw_rect(rect, modulate, false, line_thickness)

