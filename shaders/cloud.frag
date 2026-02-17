// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

uniform float iTime;

#define iChannel0 bitmap
#define texture flixel_texture2D

uniform float red_amt;
uniform float green_amt;
uniform float blue_amt;


// end of ShadertoyToFlixel header

// hash functions

#define HASHSCALE1 0.1031

//----------------------------------------------------------------------------------------
//  1 out, 1 in...
float hash11(float p)
{
	vec3 p3  = fract(vec3(p) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 2 in...
float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(vec3 p3)
{
	p3  = fract(p3 * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}




//Not able to use bit operator like <<, so use alternative noise function from YoYo
//
//https://www.shadertoy.com/view/Mls3RS
//
//And it is a better realization I think
float noise(int x,int y)
{   
    return hash12(vec2(x,y));
    float fx = float(x);
    float fy = float(y);
    
    return 2.0 * fract(sin(dot(vec2(fx, fy) ,vec2(12.9898,78.233))) * 43758.5453) - 1.0;
}

float smoothNoise(int x,int y)
{
    return noise(x,y)/4.0+(noise(x+1,y)+noise(x-1,y)+noise(x,y+1)+noise(x,y-1))/8.0+(noise(x+1,y+1)+noise(x+1,y-1)+noise(x-1,y+1)+noise(x-1,y-1))/16.0;
}

float COSInterpolation(float x,float y,float n)
{
    float r = n*3.1415926;
    float f = (1.0-cos(r))*0.5;
    return x*(1.0-f)+y*f;
    
}

float perlin2d(vec2 p) {
    ivec2 i = ivec2(p);
    vec2 frac = fract(p);
    float v1 = smoothNoise(i.x, i.y);
    float v2 = smoothNoise(i.x + 1, i.y);
    float v3 = smoothNoise(i.x, i.y + 1);
    float v4 = smoothNoise(i.x + 1, i.y + 1);
   	float i1 = COSInterpolation(v1,v2,frac.x);
    float i2 = COSInterpolation(v3,v4,frac.x);
    
    return COSInterpolation(i1,i2,frac.y);
}

// WORLEY NOISE from https://www.shadertoy.com/view/MstGRl

// Determines how many cells there are
#define NUM_CELLS 16.0

// Arbitrary random, can be replaced with a function of your choice
float _rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(vec2 co) { return hash12(co); }

// Returns the point in a given cell
vec2 get_cell_point(ivec2 cell) {
	vec2 cell_base = vec2(cell) / NUM_CELLS;
	float noise_x = rand(vec2(cell));
    float noise_y = rand(vec2(cell.yx));
    return cell_base + (0.5 + 1.5 * vec2(noise_x, noise_y)) / NUM_CELLS;
}

// Performs worley noise by checking all adjacent cells
// and comparing the distance to their points
float worley2d(vec2 coord) {
    ivec2 cell = ivec2(coord * NUM_CELLS);
    float dist = 1.0;
    
    // Search in the surrounding 5x5 cell block
    for (int x = 0; x < 5; x++) { 
        for (int y = 0; y < 5; y++) {
        	vec2 cell_point = get_cell_point(cell + ivec2(x-2, y-2));
            dist = min(dist, distance(cell_point, coord));

        }
    }
    
    dist /= length(vec2(1.0 / NUM_CELLS));
    dist = 1.0 - dist;
    return dist;
}



float fbmWorld(vec2 p, int firstOctave, int numOctaves, float persistence) 
{
    float sum = 0.0; 
    for (int i = firstOctave; i < firstOctave + numOctaves; ++i) 
    { 
        float freq = pow(2.0, float(i)); 
        float amp = pow(persistence, float(i)); 
        sum += worley2d(p * freq) * amp; 
    } 
    return sum; 
}

float fbmPerly(vec2 p, int firstOctave, int numOctaves, float persistence) 
{
    float sum = 0.0; 
    for (int i = firstOctave; i < firstOctave + numOctaves; ++i) 
    { 
        float freq = pow(2.0, float(i)); 
        float amp = pow(persistence, float(i)); 
        sum += perlin2d(p * freq) * amp; 
    } 
    return sum; 
}



// REMAP

float remap(float x, float lo1, float hi1, float lo2, float hi2) {
    return lo2 + (x - lo1) / (hi1 - lo1) * (hi2 - lo2);
}

void main() 
{

    vec2 uv = openfl_TextureCoordv;
    
    uv.y *= (openfl_TextureSize.y / openfl_TextureSize.x);
    float base = fbmWorld(uv * 0.2 + vec2(iTime * 0.005), 1, 2, 0.6);
    float detail = 0.3+0.2*fbmPerly(uv*10.0 + vec2(iTime*0.01,0.0), 3, 5, 0.8);
    float noise = remap(detail, 1.0 - base, 1.0, 0.0, 1.0) * 2.0;
    //noise = base;
    //noise = detail;
    //float red_amt = 0.5;

    gl_FragColor = vec4((noise * red_amt), (noise * green_amt), (noise * blue_amt), flixel_texture2D(bitmap, openfl_TextureCoordv).a);
}