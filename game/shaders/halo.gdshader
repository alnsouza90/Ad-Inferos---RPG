shader_type canvas_item;
// Halo and saint figure (ADR-0008, asset-pipeline §6). The spiritual state
// only changes these parameters: brightness of the halo, saturation of the
// figure, and a slow spin for the Consolation rays.
// T65: the fragment's COLOR already holds the texture times the modulate,
// so the texture is sampled again only when the rays spin, and then times
// the modulate kept from the vertex (sampling it twice squared the colours).
// Rim light (T65, Art Bible): a one-pixel edge of light on the side the
// figure faces away from, amber on the saints, the circle's colour on the
// enemies, as in the approved battle preview v2.

uniform float brightness = 1.0;
uniform float saturation = 1.0;
// Radians per second; 0 keeps the texture still.
uniform float spin_speed = 0.0;
uniform vec4 rim_color = vec4(0.0);
// -1: light on the left edge (saints), 1: on the right edge (enemies).
uniform float rim_side = -1.0;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 col = COLOR;
	if (spin_speed != 0.0) {
		float a = TIME * spin_speed;
		vec2 c = UV - vec2(0.5);
		vec2 uv = vec2(c.x * cos(a) - c.y * sin(a), c.x * sin(a) + c.y * cos(a)) + vec2(0.5);
		col = texture(TEXTURE, uv) * modulate;
		if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
			col.a = 0.0;
		}
	}
	if (rim_color.a > 0.0 && col.a > 0.0) {
		float beside = texture(TEXTURE, UV + vec2(rim_side * TEXTURE_PIXEL_SIZE.x, 0.0)).a;
		if (beside <= 0.0) {
			col.rgb = mix(col.rgb, rim_color.rgb, rim_color.a);
		}
	}
	float grey = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	col.rgb = mix(vec3(grey), col.rgb, saturation) * brightness;
	COLOR = col;
}
