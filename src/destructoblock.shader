shader_type canvas_item;


void vertex()
{
	float M_PI = 3.1415926535897932384626433832795;
	float phase = 0.;
	if (UV.x == 0. && UV.y == 1.)
	{
		phase = M_PI/2.;
	} else if (UV.x == 1. && UV.y == 1.)
	{
		phase = 3.*M_PI/2.;
	} else if (UV.x == 1. && UV.y == 0.)
	{
		phase = M_PI;
	}
	VERTEX.x = mix(VERTEX.x, 0.5+VERTEX.x/1.1, (sin(TIME*10. + phase)+1.)/2.);
	VERTEX.y = mix(VERTEX.y, 0.5+VERTEX.y/1.1, (sin(TIME*10. + phase)+1.)/2.);
}