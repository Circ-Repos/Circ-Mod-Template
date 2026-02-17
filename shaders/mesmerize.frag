// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
uniform float u_alpha;

// end of ShadertoyToFlixel header

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = texture(iChannel0, uv).rgb;
    // move to center
    uv -= 0.5;

    // pixelate it
    const float pixel_size = 0.009;
    uv = floor(uv / pixel_size) * pixel_size;

    // calculate the angle from the pixel to the center of the screen
    float ang = atan(uv.y, uv.x) + sin(iTime / 2.0) * 2.0;
    float lines = sin(ang * 100.0);

    // calculate line stuff
    float lineMask = smoothstep(-1.0, 2., lines);
    vec3 lineColor = mix(vec3(87., 0., 79.) / 255., vec3(0.3), lineMask);

    // calculate vignette stuff
    float vignette = length(uv) * u_alpha;
    float vignetteMask = smoothstep(0.3, 0.65, vignette);

    // blit to screen
    col = mix(lineColor, col, 1.0 - vignetteMask);
    fragColor = vec4(col, texture(iChannel0, uv).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}