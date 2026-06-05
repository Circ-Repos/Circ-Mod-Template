#pragma header

uniform float intensity;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 coord = openfl_TextureCoordv * openfl_TextureSize.xy;

    uv *= 1.0 - uv.yx;

    float vig = uv.x * uv.y * 15.0;
    vig = pow(vig, intensity);

    vec4 texColor = texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = texColor * vec4(vig, vig, vig, 1.0);
}
