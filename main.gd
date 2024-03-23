extends Node2D

@onready var renderer = $Renderer
@onready var settings = $Settings
# Called when the node enters the scene tree for the first time.
func _ready():
	#dataPackTest()
	#rendererTest()
	engineSetup()

func _process(delta):
	for child in get_children():
		if child is EEngine:
			child.update(delta)


func engineSetup() -> void:
	var pack = makePack()
	for child in get_children():
		if child is EEngine:
			child.Settings = settings
			child.setPack(pack)
			child.setup()

func makePack() -> Datapack:
	var data = []
	for i in range(sqrt(settings.numParticles)):
		for j in range(sqrt(settings.numParticles)):
			data.append(Vector2(i*settings.particleSpacing,j*settings.particleSpacing) + settings.Bounds / 2 * 0.85)
	return Datapack.new().create(data)


func rendererUpdateTest() -> void:
	var pack = renderer.FinalPack
	pack.write()
	for i in range(pack.length()):
		pack.put(i,pack.retrieve(i) + Vector2(0,1))
	pack.read()
	renderer.queue_redraw()

func rendererTest() -> void:
	renderer.Settings = settings
	var grid = []
	for i in range(0,100,10):
		for j in range(0,100,10):
			grid.append(Vector2(i + 300,j + 300))
	var pack = Datapack.new().create(grid)
	renderer.setPack(pack)
	renderer.queue_redraw()

func dataPackTest() -> void:
	var arr := []
	for i in range(4):
		arr.append(Vector2(randi(),randi()))
	var test = Datapack.new().create(arr)
	test.out()
	test.read()
	test.out()
	test.write()
	test.out()
