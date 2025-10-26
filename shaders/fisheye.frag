#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;

void main() 
{
    vec2 uv = fragCoord/openfl_TextureSize.xy;
    
    float depth = 6.0;

    float dx = distance(uv.x, 0.5);
    float dy = distance(uv.y, 0.5);
    
    float offset = (dx*0.2) * dy;
    
    float dir = 0.0;
    if (uv.y <= 0.5) 
        dir = 1.0;
    else
        dir = -1.0;
    
    vec2 coords = vec2(uv.x, uv.y + dx*(offset*depth*dir));
    vec2 nuv = coords;
    
    gl_FragColor = flixel_texture2D(bitmap, nuv); 
}