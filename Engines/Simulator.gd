class_name Simulator extends EEngine

var Pack : Datapack
var velocityPack : Datapack

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

	
