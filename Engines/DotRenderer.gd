class_name Renderer extends EEngine

var FinalPack : Datapack = Datapack.new().create([])

func setPack(pack: Datapack) -> void:
	FinalPack = pack
	

func _draw():
	var newPack = Datapack.new().clone(FinalPack)
	while FinalPack.length() > 0:
		draw_circle(Vector2(FinalPack.pop(),FinalPack.pop()),Settings.particleRadius,Settings.particleBaseColor)
	FinalPack = newPack
