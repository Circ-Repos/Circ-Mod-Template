// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float iTimeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](iTime, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

#define PI 3.14159265

vec2 res_scale = vec2(1, 3);

float NTSC_CRT_GAMMA = 2.5;
float NTSC_DISPLAY_GAMMA = 2.1;

#define TEX(off) max(pow(texture(iChannel0, (fragCoord / iResolution.xy) + vec2(0.0, (off) * one.y)).rgb, vec3(NTSC_CRT_GAMMA)), 0.001);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

   vec2 one = 1.0 / iResolution.xy;
   vec2 pix_no = fragCoord / res_scale;
   
   
   vec3 frame0 = TEX(-2.0);
   vec3 frame1 = TEX(-1.0);
   vec3 frame2 = TEX(0.0);
   vec3 frame3 = TEX(1.0);
   vec3 frame4 = TEX(2.0);

   float offset_dist = fract(pix_no.y) - 0.5;
   float dist0 =  2.0 + offset_dist;
   float dist1 =  1.0 + offset_dist;
   float dist2 =  0.0 + offset_dist;
   float dist3 = -1.0 + offset_dist;
   float dist4 = -2.0 + offset_dist;

   vec3 scanline = frame0 * exp(-5.0 * dist0 * dist0);
   scanline += frame1 * exp(-5.0 * dist1 * dist1);
   scanline += frame2 * exp(-5.0 * dist2 * dist2);
   scanline += frame3 * exp(-5.0 * dist3 * dist3);
   scanline += frame4 * exp(-5.0 * dist4 * dist4);

   fragColor = vec4(pow(1.15 * scanline, vec3(1.0 / NTSC_DISPLAY_GAMMA)), 1.0);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}