shader_type canvas_item;
// The village at day or night (D-492, Bíblia de Arte §10A): night pulls the
// picture to dark grey-violet, without blue; the lights of the windows, the
// torches, the forge and the candles stay lit and flicker a little.

uniform sampler2D lights : filter_nearest;
uniform float night : hint_range(0.0, 1.0) = 0.0;
uniform vec3 night_tint = vec3(0.40, 0.36, 0.48);
uniform float night_dark : hint_range(0.0, 1.0) = 0.55;
uniform float flicker : hint_range(0.0, 0.5) = 0.12;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float l = texture(lights, UV).r;
	float grey = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	vec3 dark = mix(c.rgb, vec3(grey), 0.35) * night_tint * (1.0 - night_dark) * 1.6;
	vec3 base = mix(c.rgb, dark, night * (1.0 - l));
	// Flicker by position, so the flames do not beat together.
	float f = 1.0 + flicker * sin(TIME * 6.0 + UV.x * 91.0 + UV.y * 57.0) * l;
	COLOR = vec4(base * mix(1.0, f, 0.5 + 0.5 * night) + c.rgb * l * 0.25 * night, c.a);
}
