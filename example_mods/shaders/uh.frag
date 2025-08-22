#pragma header

uniform float colorAlpha;
uniform float colorRed;
uniform float colorGreen;
uniform float colorBlue;

// The darken blend mode changes the color of the destination pixel to the darker of the two constituent colors.
// The RGB values of the provided color are compared to the RGB values of the source pixel.
// If the source pixel is darker, the destination pixel is replaced with the source pixel.
// If the source pixel is lighter, the provided color is used instead..

void main() {
	// Get the texture to apply to.
	vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

	// Apply the darken effect.
	if (color.a > colorAlpha)
		color.a = colorAlpha;
	if (color.r > colorRed)
		color.r = colorRed;
	if (color.g > colorGreen)
		color.g = colorGreen;
	if (color.b > colorBlue)
		color.b = colorBlue;

  // Return the value.
	gl_FragColor = color;
}
vec3 applyHue(vec3 aColor, float aHue)
{
    float angle = radians(aHue);
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1.0 - cosAngle);
}

vec3 applyHSBCEffect(vec3 color)
{
    color = clamp(color + ((brightness) / 255.0), 0.0, 1.0);

    color = applyHue(color, hue);

    color = clamp((color - 0.5) * (1.0 + ((contrast) / 255.0)) + 0.5, 0.0, 1.0);

    vec3 intensity = vec3(dot(color, vec3(0.30980392156, 0.60784313725, 0.08235294117)));
    color = clamp(mix(intensity, color, (1.0 + (saturation / 100.0))), 0.0, 1.0);

    return color;
}

void main()
{
	vec4 textureColor = texture2D(bitmap, openfl_TextureCoordv);

	vec3 outColor = applyHSBCEffect(textureColor.rgb);

	gl_FragColor = vec4(outColor * textureColor.a, textureColor.a);
}