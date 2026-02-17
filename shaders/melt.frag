#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

uniform float speed;

void mainImage(out vec4 o, vec2 p)
{
	p /= iResolution.xy;
    p.y -= 0.5 * iTime * fract(sin(dot(vec2(p.x), vec2(1280.0, 720.0)))* 500.0);

    o = texture(iChannel0, p);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}