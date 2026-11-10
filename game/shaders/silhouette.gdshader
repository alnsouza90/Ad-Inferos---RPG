shader_type canvas_item;
render_mode blend_add;
// A figure's silhouette in one colour of light (the outline of a dark spell,
// D-236): the texture gives only the shape; COLOR (the draw's modulate)
// gives the colour and the strength.

void fragment() {
	float a = texture(TEXTURE, UV).a;
	COLOR = vec4(COLOR.rgb * a * COLOR.a, a * COLOR.a);
}
