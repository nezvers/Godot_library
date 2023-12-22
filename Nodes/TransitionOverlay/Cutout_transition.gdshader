shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);
uniform sampler2D mask;
uniform float scale_min;
uniform float scale_max;
uniform vec2 offset;


void fragment() {
	float scale = mix(scale_min, scale_max, progress);
	vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x, 1);
	vec4 mask_color = texture(mask, ((UV - offset) * aspect)/scale + offset);
	COLOR.a = 1.0 - mask_color.a;
	//COLOR.a = mask_color.a;
}
