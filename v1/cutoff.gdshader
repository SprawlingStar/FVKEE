shader_type canvas_item;


void fragment() {
	if (UV.x < 0.5)
	{
		COLOR.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
