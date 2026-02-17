#pragma header

vec2 iResolution = openfl_TextureSize;
uniform float iTime;

uniform float darkness;
uniform float intensity;

float func(in vec2 uv, float d, float o){
    return darkness -smoothstep(0.0, d, distance(uv.x, 0.3 + abs(sin(60.0)) + sin(o+uv.y * 3.0) * 0.3));
}

vec4 diffractionF(vec2 uv, float o) {
 float d = 0.05+abs(sin(o*0.2))*0.25 * distance(uv.y+0.5, 0.0);
 return vec4(func(uv+vec2(d*0.25, 0.0), d, o), 0.0, 0.0, 1.0) +
        vec4(0.0, func(uv-vec2(0.015, 0.005), d, o), 0.0, 1.0) + 
        vec4(0.0, 0.0, func(uv-vec2(d*0.5, 0.015), d, o), 1.0);   
}


float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
        mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
        mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x), u.y
    );
    return res * res;
}


void main() {
  vec2 uv = openfl_TextureCoordv;
    
    vec4 color = texture2D(bitmap, uv);
    float speed = 1.6;
    
    float p = noise(uv * intensity);
    
    vec4 diffraction = diffractionF(uv, sin(iTime) * speed)*0.5 + 
       diffractionF(uv, iTime * 2.0 * speed)*0.5 + 
       diffractionF(uv + vec2(0.3, 0.0), iTime * speed) * 0.5;
       
       
  gl_FragColor = (diffraction * 0.5 * p + color);        
}
