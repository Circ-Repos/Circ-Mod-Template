// wooo I made this :] -Neb

#pragma header

uniform sampler2D mask;

void main() {
	vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
	vec4 mask = flixel_texture2D(mask, openfl_TextureCoordv);
	float alpha = 1.0 - (mask.b * mask.a);

	gl_FragColor = vec4(base.rgb*alpha*base.a, alpha*base.a);
}