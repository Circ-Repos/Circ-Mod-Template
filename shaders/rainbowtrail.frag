// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

//original from https://www.shadertoy.com/view/lsBSDm

// The MIT License
// Copyright  2014 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// Inverse bilinear interpolation: given four points defining a quadrilateral, compute the uv
// coordinates of any point in the plane that would give result to that point as a bilinear 
// interpolation of the four points.
//
// The problem can be solved through a quadratic equation. More information in this article:
//
// https://iquilezles.org/articles/ibilinear


float cross2d( in vec2 a, in vec2 b ) { return a.x*b.y - a.y*b.x; }

// given a point p and a quad defined by four points {a,b,c,d}, return the bilinear
// coordinates of p in the quad. Returns (-1,-1) if the point is outside of the quad.
vec2 invBilinear( in vec2 p, in vec2 a, in vec2 b, in vec2 c, in vec2 d )
{
    //!!!!!!!!!!!!!!!!!!!!!!!!
    /*fix from page https://www.shadertoy.com/view/lsBSDm
		Hackerham, 2017-08-07
		Made a fix: https://gist.github.com/ivanpopelyshev/2a75479075286deb8ee5dc1fb2e07f09
	*/
    //!!!!!!!!!!!!!!!!!!!!!!!!
    vec2 e = b-a;
    vec2 f = d-a;
    vec2 g = a-b+c-d;
    vec2 h = p-a;
        
    float k2 = cross2d( g, f );
    float k1 = cross2d( e, f ) + cross2d( h, g );
    float k0 = cross2d( h, e );
    
    float k2u = cross2d( e, g );
    float k1u = cross2d( e, f ) + cross2d( g, h );
    float k0u = cross2d( h, f);    
   
    float v1, u1, v2, u2;
    
    if (abs(k2) < 1e-5) 
    {
        v1 = -k0 / k1;
        u1 = (h.x - f.x*v1)/(e.x + g.x*v1);
    } 
    else if (abs(k2u) < 1e-5) 
    {
        u1 = k0u / k1u;
        v1 = (h.y - e.y*u1)/(f.y + g.y*u1);
    } 
    else 
    {
        float w = k1*k1 - 4.0*k0*k2;

        if( w<0.0 ) return vec2(-1.0);

        w = sqrt( w );

        v1 = (-k1 - w)/(2.0*k2);
        v2 = (-k1 + w)/(2.0*k2);
        u1 = (-k1u - w)/(2.0*k2u);
        u2 = (-k1u + w)/(2.0*k2u);
    }
    bool  b1 = v1>0.0 && v1<1.0 && u1>0.0 && u1<1.0;
    bool  b2 = v2>0.0 && v2<1.0 && u2>0.0 && u2<1.0;
    
    vec2 res = vec2(-1.0);

    if(  b1/* && !b2 */) res = vec2( u1, v1 );
    if( /*!b1 &&  */b2 ) res = vec2( u2, v2 );
    
    return res;
}

float sdSegment( in vec2 p, in vec2 a, in vec2 b )
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length( pa - ba*h );
}

vec3  hash3( float n ) { return fract(sin(vec3(n,n+1.0,n+2.0))*43758.5453123); }

//added for dithering
bool even(float a) { return fract(a/2.0) <= 0.5; }

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 p = (-iResolution.xy + 2.0*fragCoord.xy)/iResolution.y;
    
    // background
    vec3 bg = vec3( 0.35 + 0.1*p.y );
    if (fragCoord.x > iResolution.x/2.0) bg = vec3(0.35,0.35,0.35);
    vec3 col = bg;

    { //render
    	// move points
    	vec2 a = sin( 1.11*iTime + vec2(0.1,4.0) );
    	vec2 b = sin( 1.13*iTime + vec2(1.0,3.0) );
    	vec2 c = cos( 1.17*iTime + vec2(2.0,2.0) );
    	vec2 d = cos( 1.15*iTime + vec2(3.0,1.0) );
    
    	//vec2 a = vec2(0.5,-0.5);
    	//vec2 b = vec2(-0.5,-0.5);
    	//vec2 c = vec2(0.5,0.5);
    	//vec2 d = vec2(-0.5,0.5);

    	// area of the quad
    	vec2 uv = invBilinear( p, a, b, c, d );
    	if( uv.x>-0.5 )
    	{
    	    col = texture( iChannel0, uv ).xyz;
    	}
    
    	// quad borders
    	/*
		//*/
        float h = 2.0/iResolution.y;
    	col = mix( col, vec3(1.0,0.7,0.2), 1.0-smoothstep(h,2.0*h,sdSegment(p,a,b)));
    	col = mix( col, vec3(1.0,0.7,0.2), 1.0-smoothstep(h,2.0*h,sdSegment(p,b,c)));
    	col = mix( col, vec3(1.0,0.7,0.2), 1.0-smoothstep(h,2.0*h,sdSegment(p,c,d)));
    	col = mix( col, vec3(1.0,0.7,0.2), 1.0-smoothstep(h,2.0*h,sdSegment(p,d,a)));
 
    	col += (1.0/255.0)*hash3(p.x+13.0*p.y);//*/
    }
    
    //mesh or screen door or dithering like in many sega saturn games
    bool ditherEnabled = true;
    if (fragCoord.x > iResolution.x/2.0) ditherEnabled = false;
    float ditherSize = 4.0; //1 is native and difficult to see on high dpi displays
    vec2 dCoord = fragCoord/ditherSize;
    bool ditherDrawTrue = !ditherEnabled || (even(dCoord.x) && even(dCoord.y)) || (!even(dCoord.x) && !even(dCoord.y));
    
    if ( ditherDrawTrue ) fragColor = vec4(col, texture(iChannel0, fragCoord / iResolution.xy).a);
    else fragColor = vec4( bg, 1.0 );
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}