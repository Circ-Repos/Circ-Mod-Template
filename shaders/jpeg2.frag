// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define round(a) floor(a+.5)
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// Parameters to control compression quality and strength
float uQuality = 0.75;   // Compression quality (higher is worse)
float uStrength = 0.5;  // Compression strength (higher means more artifacts)

// Helper functions for DCT and IDCT
float dctCoefficient(int u, int v, float block[64]) {
    float sum = 0.0;
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            float pixel = block[x * 8 + y];
            sum += pixel * cos((2.0 * float(x) + 1.0) * float(u) * 3.14159 / 16.0) * cos((2.0 * float(y) + 1.0) * float(v) * 3.14159 / 16.0);
        }
    }
    float Cu = u == 0 ? 0.7071 : 1.0;
    float Cv = v == 0 ? 0.7071 : 1.0;
    return 0.25 * Cu * Cv * sum;
}

float idctCoefficient(int x, int y, float block[64]) {
    float sum = 0.0;
    for (int u = 0; u < 8; u++) {
        for (int v = 0; v < 8; v++) {
            float coeff = block[u * 8 + v];
            float Cu = u == 0 ? 0.7071 : 1.0;
            float Cv = v == 0 ? 0.7071 : 1.0;
            sum += Cu * Cv * coeff * cos((2.0 * float(x) + 1.0) * float(u) * 3.14159 / 16.0) * cos((2.0 * float(y) + 1.0) * float(v) * 3.14159 / 16.0);
        }
    }
    return 0.25 * sum;
}

// Main shader function
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Convert to YCoCg color space
    vec3 rgb = texture(iChannel0, fragCoord.xy / iResolution.xy).rgb;
    float Y = 0.25 * rgb.r + 0.5 * rgb.g + 0.25 * rgb.b;
    float Co = 0.5 * rgb.r - 0.5 * rgb.b;
    float Cg = -0.25 * rgb.r + 0.5 * rgb.g - 0.25 * rgb.b;

    // Block-based processing
    vec2 blockCoord = floor(fragCoord.xy / 8.0) * 8.0;
    float block[64];

    // Load block
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            vec2 coord = blockCoord + vec2(float(i), float(j));
            block[i * 8 + j] = texture(iChannel0, coord / iResolution.xy).r;
        }
    }

    // Apply DCT and quantization
    float dctBlock[64];
    for (int u = 0; u < 8; u++) {
        for (int v = 0; v < 8; v++) {
            dctBlock[u * 8 + v] = dctCoefficient(u, v, block);
            // Use uQuality to control the quantization level
            dctBlock[u * 8 + v] = round(dctBlock[u * 8 + v] / uQuality) * uQuality;
        }
    }

    // Apply IDCT
    float reconstructedBlock[64];
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            reconstructedBlock[x * 8 + y] = idctCoefficient(x, y, dctBlock);
        }
    }

    // Get the pixel value from the reconstructed block
    vec2 localCoord = mod(fragCoord.xy, 8.0);
    float reconstructedY = reconstructedBlock[int(localCoord.x) * 8 + int(localCoord.y)];

    // Convert back to RGB
    vec3 reconstructedRGB = vec3(reconstructedY + Co - Cg, reconstructedY + Cg, reconstructedY - Co - Cg);

    // Apply uStrength to control the strength of the artifacts
    reconstructedRGB = mix(rgb, reconstructedRGB, uStrength);

    // Set the final pixel color
    fragColor = vec4(reconstructedRGB, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}