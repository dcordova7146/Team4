shader_type canvas_item;
// Put a white 1-pixel outline around non-transparent pixels.
uniform vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec2 tps = TEXTURE_PIXEL_SIZE;
	// Only color transparent pixels.
	if (COLOR.a - 0.0 < 0.0001) {
		float left = UV.x - tps.x;
		float top = UV.y - tps.y;
		// Check a 3x3 area centered around the pixel for the texture.
		for (float i = left; i < left + tps.x * 3.0; i += tps.x) {
			for (float j = top; j < top + tps.y * 3.0; j += tps.x) {
				// If the texture is nearby, add the outline.
				if (texture(TEXTURE, vec2(i, j)).a > 0.0) {
					COLOR = outline_color;
					break;
				}
			}
		}
	}
}
