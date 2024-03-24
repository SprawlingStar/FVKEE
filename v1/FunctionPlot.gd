extends Sprite2D

var Settings : Settings
var data
# Called when the node enters the scene tree for the first time.
func updateImage(pack: Datapack, densityPack : Datapack):
	var dynImage = Image.create(115,64,false,Image.FORMAT_RGBA8)

	for i in range(115):
		for j in range(64):
			var value = calculateProperty(pack,Vector2(i,j),densityPack) 
			#var value =  exampleFunction(Vector2(i,j) / Vector2(115,64) *4)
			#print(value)
			print((i*j) / (115*64))
			dynImage.set_pixel(i,j,Color(value,value,value))
	
	self.texture = ImageTexture.create_from_image(dynImage)

func SmoothingFunction(radius : float, distance : float) -> float:
	var volume = PI * pow(Settings.smoothingRadius,8) / 4
	var value : float = max(0, radius*radius - distance * distance)
	return value * value * value / volume

func calculateProperty(pack : Datapack, point: Vector2,densityPack):
	var property = 0.0
	for i in range(pack.length()):
		var dst = (pack.retrieve(i) - point).length()
		var influence = SmoothingFunction(Settings.smoothingRadius,dst)
		var density = densityPack.retrieve(i)
		property += data[i] * influence * Settings.ParticleMass / density
		
	return property


func densityAtPoint(point : Vector2, Pack) -> float:
	var density = 0.0
	
	for i in range(Pack.length()):
		var pos : Vector2 = Pack.retrieve(i)
		var dst := (pos-point).length()
		var influence := SmoothingFunction(Settings.smoothingRadius,dst)
		density += Settings.ParticleMass * influence
	
	return density

func exampleFunction(pos : Vector2):
	return cos(pos.y -3 + sin(pos.x))
