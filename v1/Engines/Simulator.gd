class_name Simulator extends EEngine

var Pack : Datapack
var velocityPack : Datapack


@export var label : NodePath

func setup():
	var d = []
	for i in range(Pack.length()):
		d.append(Vector2.ZERO)
	velocityPack = Datapack.new().create(d)

func setPack(pack: Datapack) -> void:
	Pack = pack

func update(_delta : float) -> void:
	_delta *= 10
	for i in range(velocityPack.length()):
		velocityPack.change(i,Vector2.DOWN * Settings.gravity * _delta)
		Pack.change(i,velocityPack.retrieve(i) * _delta)
		ResolveCollisions(i)
	get_node(label).text = "Density: " + str(densityAtPoint(Settings.Bounds / 2))

func ResolveCollisions(index) -> void:
	var HalfBounds : Vector2 = Settings.Bounds /2 - Vector2.ONE * Settings.particleRadius #account for particle sizes
	var pos = Pack.retrieve(index) - Settings.Bounds / 2
	if abs(pos.x) > HalfBounds.x:
		pos.x = HalfBounds.x * sign(pos.x)
		velocityPack.put(index,velocityPack.retrieve(index) * -1 * Settings.collisionDamping)
	if abs(pos.y) > HalfBounds.y:
		pos.y = HalfBounds.y * sign(pos.y)
		velocityPack.put(index,velocityPack.retrieve(index) * -1 * Settings.collisionDamping)
	pos += Settings.Bounds/2
	Pack.put(index,pos)
	#conform to bounds

func SmoothingFunction(radius : float, distance : float) -> float:
	var volume = PI * pow(Settings.smoothingRadius,8) / 4
	var value : float = max(0, radius*radius - distance * distance)
	return value * value * value / volume

func densityAtPoint(point : Vector2) -> float:
	var density = 0.0
	
	for i in range(Pack.length()):
		var pos : Vector2 = Pack.retrieve(i)
		var dst := (pos-point).length()
		var influence := SmoothingFunction(Settings.smoothingRadius,dst)
		density += Settings.ParticleMass * influence
	
	return density
