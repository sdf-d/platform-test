shader_type canvas_item;
uniform float hp=0.4;

void vertex()
{
	VERTEX.x *= 0.3;
	VERTEX.y *= 0.3;
}

void fragment()
{
	float visible = 0.25;
	if (hp >= UV.x)
	{
		visible = 1.;
	}
	COLOR = texture(TEXTURE,UV);
	COLOR.w = COLOR.w  * visible;
	
}