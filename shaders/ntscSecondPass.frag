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


#define TAPS 32

const float smoothness = 1.0;

const float luma_filter[TAPS + 1] = float[TAPS + 1](
   -0.000174844, -0.000205844, -0.000149453, -0.000051693,
   0.000000000, -0.000066171, -0.000245058, -0.000432928,
   -0.000472644, -0.000252236, 0.000198929, 0.000687058,
   0.000944112, 0.000803467, 0.000363199, 0.000013422,
   0.000253402, 0.001339461, 0.002932972, 0.003983485,
   0.003026683, -0.001102056, -0.008373026, -0.016897700,
   -0.022914480, -0.021642347, -0.008863273, 0.017271957,
   0.054921920, 0.098342579, 0.139044281, 0.168055832,
   0.178571429
);

const float chroma_filter[TAPS + 1] = float[TAPS + 1](
   0.001384762, 0.001678312, 0.002021715, 0.002420562,
   0.002880460, 0.003406879, 0.004004985, 0.004679445,
   0.005434218, 0.006272332, 0.007195654, 0.008204665,
   0.009298238, 0.010473450, 0.011725413, 0.013047155,
   0.014429548, 0.015861306, 0.017329037, 0.018817382,
   0.020309220, 0.021785952, 0.023227857, 0.024614500,
   0.025925203, 0.027139546, 0.028237893, 0.029201910,
   0.030015081, 0.030663170, 0.031134640, 0.031420995,
   0.031517031
);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float one_x = 1.0 / (iResolution.x / smoothness);
	vec3 signal = vec3(0.0);
    
    float offset;
    vec3 sums;
    
    #define fetch_offset(offset, one_x) \
        texture(iChannel0, (fragCoord / iResolution.xy) + vec2((offset) * (one_x), 0.0)).xyz
    
    #define macro_loopz(c) offset = float(c) - 1.0; \
		sums = fetch_offset(offset - 32.0, one_x) + fetch_offset(32. - offset, one_x); \
            signal += sums * vec3(luma_filter[c], chroma_filter[c], chroma_filter[c]);
    
    macro_loopz(1)
	macro_loopz(2)
	macro_loopz(3)
	macro_loopz(4)
	macro_loopz(5)
	macro_loopz(6)
	macro_loopz(7)
	macro_loopz(8)
	macro_loopz(9)
	macro_loopz(10)
	macro_loopz(11)
	macro_loopz(12)
	macro_loopz(13)
	macro_loopz(14)
	macro_loopz(15)
	macro_loopz(16)
	macro_loopz(17)
	macro_loopz(18)
	macro_loopz(19)
	macro_loopz(20)
	macro_loopz(21)
	macro_loopz(22)
	macro_loopz(23)
	macro_loopz(24)
	macro_loopz(25)
	macro_loopz(26)
	macro_loopz(27)
	macro_loopz(28)
	macro_loopz(29)
	macro_loopz(30)
	macro_loopz(31)
	macro_loopz(32)
    
    signal += texture(iChannel0, fragCoord / iResolution.xy).xyz * vec3(luma_filter[32], chroma_filter[32], chroma_filter[32]);
    
    vec3 rgb = yiq2rgb(signal);
	fragColor = vec4(rgb, 1.0);
}


void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}