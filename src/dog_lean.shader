shader_type canvas_item;
uniform int run_state = 0;

void vertex()
{
	if (UV.y == 0.)
	{
		if(run_state == 1)
		{
			VERTEX.x += 6.;
		} else if (run_state == -1)
		{
			VERTEX.x -= 6.;
		}
	}
}