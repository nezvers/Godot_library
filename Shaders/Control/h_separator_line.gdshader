shader_type canvas_item;

uniform vec4 tint:source_color;

void fragment() {
	float a = sin(UV.x * PI) * 0.25;
	COLOR = vec4(tint.xyz, a * 2.0);
}
