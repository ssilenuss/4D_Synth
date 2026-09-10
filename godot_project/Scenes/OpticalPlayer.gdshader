shader_type canvas_item;

//uniform sampler2D soundtrack;
uniform int image_height = 512;

void fragment()
{
	float sum = 0.0;

	for (int y = 0; y < image_height; y++)
	{
		float fy =
			(float(y) + 0.5)
			/ float(image_height);

		sum += texture(
			TEXTURE,//soundtrack,
			vec2(UV.x, fy)
		).r;
	}

	float average =
		sum / float(image_height);

	COLOR = vec4(
		average,
		average,
		average,
		1.0);}