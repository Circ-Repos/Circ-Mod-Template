#pragma header

uniform vec4 uReplaceColor; // RGBA 0..1

// Two thresholds for a smooth transition:
// - uBlackMin: below this = treated as black (keep original)
// - uBlackMax: above this = treated as non-black (replace)

uniform float uBlackMin;
uniform float uBlackMax;

void main()
{
    vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);

    // keep transparency
    if (tex.a <= 0.0)
    {
        gl_FragColor = tex;
        return;
    }

    // "brightness" of pixel (how far from black it is)
    float brightness = max(tex.r, max(tex.g, tex.b));

    // Smooth blend:
    // 0.0 = keep original (black)
    // 1.0 = fully replaced
    float t = smoothstep(uBlackMin, uBlackMax, brightness);

    vec4 replaced = vec4(uReplaceColor.rgb, tex.a * uReplaceColor.a);

    gl_FragColor = mix(tex, replaced, t);
}