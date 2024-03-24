extends Sprite2D



func _process(delta):
	var dynImage = Image.create(115,64,false,Image.FORMAT_RGBA8)
	for i in range(115):
		for j in range(64):
			var value = 0
			#var value =  exampleFunction(Vector2(i,j) / Vector2(115,64) *4)
			#print(value)
			dynImage.set_pixel(i,j,Color(value,value,value))
	
	self.texture = ImageTexture.create_from_image(dynImage)
