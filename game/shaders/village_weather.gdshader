shader_type canvas_item;
// The village's weather (D-495): in Advent and Lent the sky turns greyer and
// cloudier and the light over the village greyer and misty. `grey` is 0 in
// the other seasons.

uniform float grey : hint_range(0.0, 1.0) = 0.0;
uniform float darken : hint_range(0.0, 1.0) = 0.25;
uniform vec3 tint = vec3(0.62, 0.62, 0.66);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float l = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	vec3 g = mix(vec3(l), c.rgb, 0.25) * tint * (1.0 - darken) * 1.25;
	COLOR = vec4(mix(c.rgb, g, grey), c.a);
}
