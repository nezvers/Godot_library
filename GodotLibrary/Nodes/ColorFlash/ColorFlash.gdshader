shader_type canvas_item;

uniform vec4 overlay:source_color;
uniform float blend:hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;

void fragment() {
	vec4 orig = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 col = mix(orig, overlay, blend);
	// weird alpha look
    if (orig.a > 0.0001) {
        col.rgb = col.rgb / orig.a;
    }
	col.a = orig.a;
    COLOR *= col;
}
