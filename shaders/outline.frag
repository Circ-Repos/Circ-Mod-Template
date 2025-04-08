#pragma header

uniform float border_fade_outer;
uniform float border_fade_inner;
uniform float border_width;
uniform vec3 border_color;
uniform bool enabled;

void main() {
	vec2 uv = openfl_TextureCoordv;
	vec4 c = flixel_texture2D(bitmap, uv);

	if (!enabled) {
		gl_FragColor = c;
		return;
	}

	vec2 fragCoord = uv * openfl_TextureSize.xy;

	bool i = bool(step(0.5, c.a) == 1.0);

	const int md = 20;
	const int h_md = md / 2;

	float d = float(md);

	for (int x = -h_md; x != h_md; ++x)
	{
		for (int y = -h_md; y != h_md; ++y)
		{
			vec2 o = vec2(float(x), float(y));
			vec2 s = (fragCoord + o) / openfl_TextureSize.xy;

			float o_a = flixel_texture2D(bitmap, s).a;
			bool o_i = bool(step(0.5, o_a) == 1.0);

			if (!i && o_i || i && !o_i)
				d = min(d, length(o));
		}
	}

	d = clamp(d, 0.0, float(md)) / float(md);

	if (i)
		d = -d;

	d = d * 0.5 + 0.5;
	d = 1.0 - d;

	float outer = smoothstep(0.5 - (border_width + border_fade_outer), 0.5, d);

	vec3 temp = vec3(0.0, 0.0, 0.0);
	vec4 border = mix(vec4(temp, 0.0), vec4(border_color, 1.0), outer);

	float inner = smoothstep(0.5, 0.5 + border_fade_inner, d);

	vec4 color = mix(border, c, inner);

	gl_FragColor = color;
}