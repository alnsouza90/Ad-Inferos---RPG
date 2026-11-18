shader_type canvas_item;
// The village's sunset sky (D-496): drawn by the engine, in pixels. Amber at
// the horizon fading to dusk violet-brown at the top, the sun's glow low and
// a little right of centre, and long thin clouds drifting slowly, lit amber
// from below. No flat gold (Bíblia de Arte §9).

uniform vec2 size = vec2(960.0, 540.0);
uniform float pixel = 2.0;
uniform float drift = 6.0;
uniform vec3 top_color = vec3(0.17, 0.11, 0.12);
uniform vec3 mid_color = vec3(0.55, 0.27, 0.14);
uniform vec3 low_color = vec3(0.93, 0.58, 0.26);
uniform vec3 sun_color = vec3(1.0, 0.82, 0.52);
uniform vec2 sun_pos = vec2(0.80, 0.36);
uniform float horizon = 0.45;

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float noise(vec2 p) {
	vec2 i = floor(p); vec2 f = fract(p); f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x), mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}
float fbm(vec2 p) {
	float v = 0.0; float a = 0.5;
	for (int i = 0; i < 4; i++) { v += a * noise(p); p *= 2.0; a *= 0.5; }
	return v;
}

void fragment() {
	// Hard pixels: the sky is drawn on a coarse grid, like the art.
	vec2 px = floor(UV * size / pixel) * pixel;
	vec2 uv = px / size;
	float t = clamp(uv.y / horizon, 0.0, 1.0);
	vec3 sky = mix(top_color, mid_color, smoothstep(0.0, 0.7, t));
	sky = mix(sky, low_color, smoothstep(0.55, 1.0, t));
	vec2 d = (uv - sun_pos) * vec2(size.x / size.y, 1.0);
	float glow = exp(-dot(d, d) * 9.0);
	sky = mix(sky, sun_color, glow * 0.85);
	// Long clouds, stretched sideways, drifting.
	vec2 cp = vec2(px.x / size.x * 4.0 + TIME * drift / size.x * 4.0, px.y / size.y * 7.0);
	float c = fbm(cp + vec2(fbm(cp * 0.7) * 1.5, 0.0));
	float band = smoothstep(0.08, 0.5, uv.y) * (1.0 - smoothstep(0.55, 0.75, uv.y));
	float cloud = smoothstep(0.56, 0.62, c) * band;
	// A darker underside and an amber rim on top, as the sun is low.
	float rim = smoothstep(0.56, 0.62, fbm(cp - vec2(0.0, 0.08))) * band - cloud;
	vec3 body = mix(vec3(0.20, 0.12, 0.12), vec3(0.42, 0.22, 0.15), smoothstep(0.1, 1.0, t));
	sky = mix(sky, body, cloud * 0.9);
	sky = mix(sky, low_color, clamp(rim, 0.0, 1.0) * (0.55 + glow));
	// Few colour steps, as pixel art.
	sky = floor(sky * 14.0 + 0.5) / 14.0;
	COLOR = vec4(sky, 1.0);
}
