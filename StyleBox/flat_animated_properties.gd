class_name AnimatedStyleBoxFlat
extends StyleBoxFlat

const default_values:Dictionary = {
	content_margin_bottom = 0.0,
	content_margin_left = 0.0,
	content_margin_right = 0.0,
	content_margin_top = 0.0,
	anti_aliasing = false,
	anti_aliasing_size = 1.0,
	bg_color = Color.BLACK,
	border_blend = false,
	border_color = Color(0.8, 0.8, 0.8, 1),
	border_width_bottom = 0,
	border_width_left = 0,
	border_width_right = 0,
	border_width_top = 0,
	corner_detail = 8,
	corner_radius_bottom_left = 0,
	corner_radius_bottom_right = 0,
	corner_radius_top_left = 0,
	corner_radius_top_right = 0,
	draw_center = true,
	expand_margin_bottom = 0.0,
	expand_margin_left = 0.0,
	expand_margin_right = 0.0,
	expand_margin_top = 0.0,
	shadow_color = Color(0, 0, 0, 0.6),
	shadow_offset = Vector2(0, 0),
	shadow_size = 0,
	skew = Vector2(0, 0)
}

@export var normal:Dictionary = default_values
@export var pressed:Dictionary = default_values
@export var focus:Dictionary = default_values
@export var hover:Dictionary = default_values

