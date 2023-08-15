shader_type canvas_item;

uniform vec2 size = vec2(217,55);// need to provide size
uniform float scale = 1.0;
uniform float rotation = 0.0;
uniform vec2 sckew = vec2(0.0, 0.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec2 stretch = vec2(1.0, 1.0);
uniform vec4 overlay: source_color = vec4(1.0);

varying vec4 MODULATE; // seems to be a removed built-in variable
void vertex(){
	vec2 half_size = size * 0.5;
	vec2 skew_offset = sckew * -(UV.yx - vec2(0.5, 0.5)) * 2.0;
	vec2 from_center = VERTEX - half_size + skew_offset;
	float len = length(from_center);
	float angle = atan(from_center.y, from_center.x);
	angle = (angle + radians(rotation));
	from_center.x = cos(angle) * len;
	from_center.y = sin(angle) * len;
	
	VERTEX = scale * from_center * stretch + half_size + offset;
	MODULATE = COLOR;
}

void fragment(){
	COLOR.rgb = mix(COLOR.rgb, overlay.rgb, overlay.a);
	
}


