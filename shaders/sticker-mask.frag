#pragma header

void main()
{

    vec4 tex = flixel_texture2D(bitmap,openfl_TextureCoordv);

    gl_FragColor = vec4(mix(tex.rgb, vec3(0.0), 1.0), 1.0 - tex.a);
}
