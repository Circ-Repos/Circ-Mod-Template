#pragma header

uniform float uQuality;   // 0.0 = high quality (low compression), 1.0 = max compression
uniform float uStrength;  // 0.0 = no effect, 1.0 = full effect

// RGB to YCbCr conversion
vec3 rgb2ycbcr(vec3 rgb) {
    float y  =  0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    float cb = -0.168736 * rgb.r - 0.331264 * rgb.g + 0.5 * rgb.b + 0.5;
    float cr =  0.5 * rgb.r - 0.418688 * rgb.g - 0.081312 * rgb.b + 0.5;
    return vec3(y, cb, cr);
}

// YCbCr to RGB conversion
vec3 ycbcr2rgb(vec3 ycbcr) {
    float y = ycbcr.x;
    float cb = ycbcr.y - 0.5;
    float cr = ycbcr.z - 0.5;

    float r = y + 1.402 * cr;
    float g = y - 0.344136 * cb - 0.714136 * cr;
    float b = y + 1.772 * cb;

    return vec3(r, g, b);
}

// Quantize a value to steps based on quality (higher quality = more steps)
float quantize(float value, float quality) {
    float steps = mix(256.0, 16.0, clamp(quality, 0.0, 1.0));
    return floor(value * steps) / steps;
}

// Average colors inside a pixelation block by sampling a grid of pixels
vec4 pixelateBlock(vec2 uv, vec2 pixelSize, vec2 resolution, int samples) {
    vec4 sumColor = vec4(0.0);
    // Find top-left corner of the block
    vec2 blockOrigin = floor(uv / pixelSize) * pixelSize;

    // Sample evenly inside block (samples x samples grid)
    for (int x = 0; x < samples; x++) {
        for (int y = 0; y < samples; y++) {
            // Calculate offset inside block [0..1)
            vec2 offset = (vec2(float(x), float(y)) + 0.5) / float(samples);
            vec2 sampleUV = blockOrigin + offset * pixelSize;
            sumColor += texture2D(bitmap, sampleUV);
        }
    }
    return sumColor / float(samples * samples);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 resolution = openfl_TextureSize;

    float blockSize = mix(1.0, 12.0, clamp(uQuality, 0.0, 1.0));
    vec2 pixelSize = blockSize / resolution;

    // Number of samples per block edge (adjust for performance/quality)
    int samples = 3;

    // Get averaged pixelated color over block
    vec4 pixelated = pixelateBlock(uv, pixelSize, resolution, samples);

    // Convert to YCbCr
    vec3 ycbcr = rgb2ycbcr(pixelated.rgb);

    // Quantize chroma channels based on quality
    ycbcr.y = quantize(ycbcr.y, uQuality);
    ycbcr.z = quantize(ycbcr.z, uQuality);

    // Convert back to RGB
    vec3 compressedRGB = ycbcr2rgb(ycbcr);
    compressedRGB = clamp(compressedRGB, 0.0, 1.0);

    // Sample original color (non-pixelated)
    vec4 original = texture2D(bitmap, uv);

    // Blend between original and compressed pixelated color
    vec3 blendedColor = mix(original.rgb, compressedRGB, uStrength);

    gl_FragColor = vec4(blendedColor, original.a);
}
