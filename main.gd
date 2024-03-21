extends Node2D

@onready var renderer = $Renderer
@onready var settings = $Settings
# Called when the node enters the scene tree for the first time.
func _ready():
	#dataPackTest()
	rendererTest()

func _process(delta):
	rendererUpdateTest()

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
	pack.read()
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
