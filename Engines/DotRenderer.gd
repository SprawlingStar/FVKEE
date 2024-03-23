class_name Renderer extends EEngine

var FinalPack : Datapack



func setPack(pack: Datapack) -> void:
	FinalPack = pack

func update(_delta : float) -> void:
	queue_redraw()

func _draw():
	var newPack = Datapack.new().clone(FinalPack)
	while newPack.length() > 0:
		#MASSIVE INNEFICENCY WITH CLONING REVISIT
		draw_circle(newPack.pop(),Settings.particleRadius,Settings.particleBaseColor)
