shader_type canvas_item;
// Filter of the circle, model B (D-379): the brightness of each pixel of the
// scenery is taken to the colour ramp of the circle and mixed with the
// original. Only scenery layers use it; never characters, interface or
// effects.
// In Godot 4 the fragment's COLOR already holds the texture times the
// modulate: sampling TEXTURE again would square every colour (T65).

uniform sampler2D ramp : filter_linear, repeat_disable;
uniform float strength = 0.5;

void fragment() {
	vec4 col = COLOR;
	float grey = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	vec3 tinted = texture(ramp, vec2(grey, 0.5)).rgb;
	col.rgb = mix(col.rgb, tinted, strength);
	COLOR = col;
}
