@tool
class_name CustomLabel
extends CanvasItem

enum HORIZONTAL_ALIGNMENT {HORIZONTAL_ALIGNMENT_LEFT, HORIZONTAL_ALIGNMENT_CENTER, HORIZONTAL_ALIGNMENT_RIGHT, HORIZONTAL_ALIGNMENT_FILL}

@export_multiline var text:String : set = set_text
@export_range(0.0, 1.0) var visible_ratio:float = 1.0 : set = set_visible_ratio
@export var font:Font : set = set_font
@export var font_size:int = 41 : set = set_font_size
@export var text_offset:Vector2 : set = set_text_offset
@export var line_height:float = 41 : set = set_line_height
@export var horizontal_alignment:HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT : set = set_horizontal_alignment
@export var width:float = -1 : set = set_width
@export var max_lines:int = -1 : set = set_max_lines
@export_flags("BREAK_NONE","BREAK_MANDATORY","BREAK_WORD_BOUND","BREAK_GRAPHEME_BOUND","BREAK_ADAPTIVE","BREAK_TRIM_EDGE_SPACES") var line_break:int = 1 : set = set_line_break
@export_flags("JUSTIFICATION_NONE","JUSTIFICATION_KASHIDA","JUSTIFICATION_WORD_BOUND","JUSTIFICATION_TRIM_EDGE_SPACES","JUSTIFICATION_AFTER_LAST_TAB","JUSTIFICATION_CONSTRAIN_ELLIPSIS") var justification = 1 : set = set_justification
@export_flags("DIRECTION_AUTO","DIRECTION_LTR","DIRECTION_RTL","DIRECTION_INHERITED") var direction:int = 1 : set = set_direction
@export_flags("ORIENTATION_HORIZONTAL","ORIENTATION_VERTICAL") var orientation:int = 1 : set = set_orientation

func set_text(value:String)->void:
	text = value
	queue_redraw()

func set_visible_ratio(value:float)->void:
	visible_ratio = value
	queue_redraw()

func set_font(value:Font)->void:
	font = value
	queue_redraw()

func set_font_size(value:int)->void:
	font_size = value
	queue_redraw()

func set_text_offset(value:Vector2)->void:
	text_offset = value
	queue_redraw()

func set_line_height(value:float)->void:
	line_height = value
	queue_redraw()

func set_horizontal_alignment(value:HorizontalAlignment)->void:
	horizontal_alignment = value
	queue_redraw()

func set_width(value:float)->void:
	width = value
	queue_redraw()

func set_max_lines(value:int)->void:
	max_lines = value
	queue_redraw()

func set_line_break(value:int)->void:
	line_break = value
	queue_redraw()

func set_justification(value:int)->void:
	justification = value
	queue_redraw()

func set_direction(value:int)->void:
	direction = value
	queue_redraw()

func set_orientation(value:int)->void:
	orientation = value
	queue_redraw()

func _draw()->void:
	if text.is_empty():
		return
	var char_count: = text.length()
	var lines:Array[String] = [""]
	var line_index: = 0
	for i in char_count:
		if text[i] == "\n":
			lines.append("")
			line_index += 1
			continue
		if float(i)/char_count < visible_ratio:
			lines[line_index] += text[i]
	for i in lines.size():
		draw_multiline_string(font, text_offset + (i * line_height) * Vector2.DOWN, lines[i], horizontal_alignment, width, font_size,max_lines, modulate, line_break, justification, orientation)
