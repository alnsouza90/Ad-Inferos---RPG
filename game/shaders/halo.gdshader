shader_type canvas_item;
// Halo and saint figure (ADR-0008, asset-pipeline §6). The spiritual state
// only changes these parameters: brightness of the halo, saturation of the
// figure, and a slow spin for the Consolation rays.

uniform float brightness = 1.0;
uniform float saturation = 1.0;
// Radians per second; 0 keeps the texture still.
uniform float spin_speed = 0.0;

void fragment() {
	vec2 uv = UV;
	if (spin_speed != 0.0) {
		float a = TIME * spin_speed;
		vec2 c = uv - vec2(0.5);
		uv = vec2(c.x * cos(a) - c.y * sin(a), c.x * sin(a) + c.y * cos(a)) + vec2(0.5);
	}
	vec4 col = texture(TEXTURE, uv);
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		col.a = 0.0;
	}
	float grey = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	col.rgb = mix(vec3(grey), col.rgb, saturation) * brightness;
	COLOR = col * COLOR;
}
