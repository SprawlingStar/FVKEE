extends Sprite2D

var Settings : Settings
var data
# Called when the node enters the scene tree for the first time.
func _ready():
	var dynImage = Image.create(115,64,false,Image.FORMAT_RGBA8)

	for i in range(115):
		for j in range(64):
			#var value = calculateProperty(pack,Vector2(i,j)) * 100
			var value =  exampleFunction(Vector2(i,j) / Vector2(115,64) *4)
			dynImage.set_pixel(i,j,Color(value,value,value))
	
	self.texture = ImageTexture.create_from_image(dynImage)

func SmoothingFunction(radius : float, distance : float) -> float:
	var volume = PI * pow(Settings.smoothingRadius,8) / 4
	var value : float = max(0, radius*radius - distance * distance)
	return value * value * value / volume

func calculateProperty(pack : Datapack, point: Vector2):
	var property = 0.0
	for i in range(pack.length()):
		var dst = (pack.retrieve(i) - point).length()
		var influence = SmoothingFunction(Settings.smoothingRadius,dst)
		property += data[i] * influence * Settings.ParticleMass
		
	return property

func exampleFunction(pos : Vector2):
	return cos(pos.y -3 + sin(pos.x))
