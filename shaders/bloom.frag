// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// Simple Bloom Shader (single-pass approximation)

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // Base color
    vec3 col = texture(iChannel0, uv).rgb;
    
    // Bloom settings
    float threshold = 0.6;   // brightness cutoff
    float intensity = 0.5;   // bloom strength
    float radius = 1;      // blur radius

    vec3 bloom = vec3(0.0);
    float total = 0.0;

    // Sample around pixel
    for (float x = -radius; x <= radius; x++)
    {
        for (float y = -radius; y <= radius; y++)
        {
            vec2 offset = vec2(x, y) / iResolution.xy;

            vec3 sampleCol = texture(iChannel0, uv + offset).rgb;

            // brightness (luminance)
            float brightness = dot(sampleCol, vec3(0.2126, 0.7152, 0.0722));

            // only bloom bright areas
            if (brightness > threshold)
            {
                float weight = 1.0 - length(vec2(x, y)) / radius;
                bloom += sampleCol * weight;
                total += weight;
            }
        }
    }

    if (total > 0.0)
        bloom /= total;

    // Combine original + bloom
    vec3 finalColor = col + bloom * intensity;

    fragColor = vec4(finalColor, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}