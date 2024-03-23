extends Node2D

@onready var renderer = $Renderer
@onready var settings = $Settings
# Called when the node enters the scene tree for the first time.
func _ready():
	densityTest()
	
	#dataPackTest()
	#rendererTest()
	#ngineSetup()

func _process(delta):
	pass
	#for child in get_children():
	#	if child is EEngine:
	#		child.update(delta)


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


func densityTest() -> void:
	var data = []
	seed(0)
	for i in range(400):
		data.append(Vector2(randf() * 115, randf() * 64))
	var pack = Datapack.new().create(data)
	$Simulator.Settings = settings
	$FunctionPlot.Settings = settings
	$Simulator.setPack(pack)
	var densityData = []
	var densityPack = []
	for i in range(400):
		densityData.append($FunctionPlot.exampleFunction(pack.retrieve(i) / Vector2(115,64) * 4))
		densityPack.append($FunctionPlot.densityAtPoint(pack.retrieve(i),pack))
	$FunctionPlot.data = densityData
	$FunctionPlot.updateImage(pack,Datapack.new().create(densityPack))
	$FunctionPlot.queue_redraw()

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
