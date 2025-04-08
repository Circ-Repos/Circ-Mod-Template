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

// COMPOSITING
#define SATURATION 1.0
#define BRIGHTNESS 1.0
#define ARTIFACTING 1.0
#define FRINGING 1.0

#define CHROMA_MOD_FREQ (4.0 * PI / 15.0)

// UNCOMMENT FOR SVIDEO
//define BRIGHTNESS 1.0
//define BRIGHTNESS 1.0
//define ARTIFACTING 1.0
//define FRINGING 1.0


// UNCOMMENT FOR THREE PAGE
//define CHROMA_MOD_FREQ (4.0 * PI / 15.0)


const mat3 yiq2rgb_mat = mat3(
   1.0, 0.956, 0.6210,
   1.0, -0.2720, -0.6474,
   1.0, -1.1060, 1.7046
);

vec3 yiq2rgb(vec3 yiq)
{
   return yiq * yiq2rgb_mat;
}

mat3 mix_mat = mat3(
	BRIGHTNESS, FRINGING, FRINGING,
	ARTIFACTING, 2.0 * SATURATION, 0.0,
	ARTIFACTING, 0.0, 2.0 * SATURATION
);

const mat3 yiq_mat = mat3(
      0.2989, 0.5870, 0.1140,
      0.5959, -0.2744, -0.3216,
      0.2115, -0.5229, 0.3114
);

vec3 rgb2yiq(vec3 col)
{
   return col * yiq_mat;
}


const float screen_start = 0.05;
const float screen_end = 0.95;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 pix_no = fragCoord / res_scale;
    pix_no.y += floor(iTime * 30.0);
    pix_no.y = floor(pix_no.y);
    
    vec3 col = texture(iChannel0, (floor(fragCoord / res_scale) * res_scale) / iResolution.xy).rgb;
    if (fragCoord.x / iResolution.x < screen_start) { col = vec3(0.0); }
    if (fragCoord.x / iResolution.x > screen_end) { col = vec3(0.0); }
	vec3 yiq = rgb2yiq(col);

    float chroma_phase = PI * (mod(pix_no.y, 2.0) + float(50));

	float mod_phase = chroma_phase + pix_no.x * CHROMA_MOD_FREQ;

	float i_mod = cos(mod_phase);
	float q_mod = sin(mod_phase);

	yiq.yz *= vec2(i_mod, q_mod); // Modulate.
	yiq *= mix_mat; // Cross-talk.
	yiq.yz *= vec2(i_mod, q_mod); // Demodulate.
	fragColor = vec4(yiq, 1.0);
}


void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}