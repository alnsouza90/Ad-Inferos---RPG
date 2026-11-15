shader_type canvas_item;
render_mode blend_add;
// A figure's silhouette in one colour of light (the outline of a dark spell,
// D-236): the texture gives only the shape; the draw's modulate gives the
// colour and the strength. COLOR already holds texture times modulate, so
// its alpha is shape times strength (T65).

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	float a = COLOR.a;
	COLOR = vec4(modulate.rgb * a, a);
}
