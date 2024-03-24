extends Sprite2D

var parent

func update():
	parent = get_parent()
	var dynImage = Image.create(115,64,false,Image.FORMAT_RGBA8)
	for i in range(115):
		for j in range(64):
			var value = parent.exampleFunction(Vector2(i,j) / parent.bounds * 4) #calculateProperty(Vector2(i,j))
			#print(value)
			dynImage.set_pixel(i,j,Color(value,value,value))
	
	self.texture = ImageTexture.create_from_image(dynImage)

func calculateProperty(point : Vector2) -> float:
	var property = 0.0
	
	for i in range(parent.numParticles):
		var dst = (parent.positions[i] - point).length()
		var influence = parent.smoothingFunction(dst / parent.bounds.length())
		var density = parent.densityAtPoint(parent.positions[i])
		property += parent.values[i] * influence * parent.mass / density
	return property
