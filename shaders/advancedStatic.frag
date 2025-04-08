/** @author TheLeerName */

#pragma header

precision lowp float;

uniform float iTime;

uniform vec4 color; // 0...1, with alpha
uniform vec2 size; // pixels
uniform float frameRate;
uniform bool mixColors;

// https://www.shadertoy.com/view/ltB3zD
// Golden Ratio
#define PHI 1.61803398874989484820459
float gold_noise(in vec2 xy, in float seed) {
	return fract(tan(distance(xy*PHI, xy)*seed)*xy.x);
}

// fragCoord - (openfl_TextureCoordv*openfl_TextureSize, or if you in shadertoy just 2nd arg in void mainImage)
// seed - u can use iTime for it
// size - in pixels ig
float staticSized(vec2 fragCoord, float seed, vec2 size) {
	fragCoord = floor(fragCoord / size) + 1.;
	return gold_noise(fragCoord, seed);
}

void main() {
	// adding main texture
	gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

	// init some vecs
	vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
	float seed = floor(iTime * frameRate) / frameRate;

	// applying static
	if (mixColors) {
		gl_FragColor.rgb = mix(gl_FragColor.rgb, color.rgb, floor(staticSized(fragCoord, seed, size)+.5) * gl_FragColor.a * color.a);
	}
	else
	{
		gl_FragColor.r = mix(gl_FragColor.r, color.r, floor(staticSized(fragCoord, seed, size)+.5) * gl_FragColor.a * color.a);
		gl_FragColor.g = mix(gl_FragColor.g, color.g, floor(staticSized(fragCoord, seed+.1, size)+.5) * gl_FragColor.a * color.a);
		gl_FragColor.b = mix(gl_FragColor.b, color.b, floor(staticSized(fragCoord, seed+.2, size)+.5) * gl_FragColor.a * color.a);
	}
}