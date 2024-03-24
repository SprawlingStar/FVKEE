extends Sprite2D

var parent

@export var targetDensity = 1.0
@export var pressureMultiplier = 1.0

func densityToPressure(density):
	var error = density - targetDensity
	var pressure = error * pressureMultiplier
	return pressure

var sizeX = 115/2
var sizeY = 64/2

func update():
	if not visible:
		return
	parent = get_parent()
	var dynImage = Image.create(sizeX,sizeY,false,Image.FORMAT_RGBA8)
	for i in range(sizeX):
		for j in range(sizeY):
			
			var value = densityToPressure(parent.densityAtPoint(Vector2(i,j)))#parent.exampleFunction(Vector2(i,j) / parent.bounds * 4) #calculateProperty(Vector2(i,j))
			dynImage.set_pixel(i,j,Color.BLUE.lerp(Color.RED,value + 1))	
			#if value.distance_:
				#dynImage.set_pixel(i,j,Color.WHITE)
	
	self.texture = ImageTexture.create_from_image(dynImage)

func calculateProperty(point : Vector2) -> float:
	var property = 0.0
	
	for i in range(parent.numParticles):
		var dst = (parent.positions[i] - point).length()
		var influence = parent.smoothingFunction(dst / parent.bounds.length())
		var density = parent.densityAtPoint(parent.positions[i])
		property += parent.values[i] * influence * parent.mass / density
	return property
