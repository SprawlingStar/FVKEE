extends Node2D

var velocities = []
var positions = []

var likelyParticles = []

@export var particleCount = 100
@export var blurRadius = 0.1
@export var particleRadius = 5.0
@export_range(0,3,0.01) var pressureStrength = 1.0
@export_range(0,1,0.1) var collisionDamping = 0.7
@export var gravity := Vector2(0,0.1)
var bounds = Vector2(1152,648)

func _ready():

	for i in range(particleCount):
		makeParticle()
	
	

func makeParticle():
	positions.append(bounds/2)
	#positions.append(Vector2(randf(),randf()) * bounds)
	velocities.append(Vector2(randf() * 2 - 1,0))
	likelyParticles.append([])

func _draw():
	for i in range(len(positions)):
		draw_circle(positions[i],particleRadius,Color("#001b48").lerp(Color("#018abd"),float(i)/particleCount))
	#draw_circle(positions[0],particleRadius,Color(Color.NAVY_BLUE,.5))
		#draw_line(positions[i],positions[i] + getDensityVector(i),Color.REBECCA_PURPLE)
		#draw_circle(positions[i],10,Color(Color.BLUE,0.2))

func getDensityVector(index):
	var result = Vector2.ZERO
	#var removeList= []
	#for j in range(len(likelyParticles[index])):
		#
		#var i = likelyParticles[index][j]
		#var difference = positions[i] - positions[index]
		#if difference.length() < blurRadius:
			#result += -difference.normalized() * (blurRadius - difference.length()) * pressureStrength * pressureStrength
		#if difference.length() > blurRadius * 1.25:
			#removeList.append(j)
	#for el in removeList:
		#likelyParticles[index].remove_at(el)
	for i in range(particleCount):
		var difference = positions[i] - positions[index]
		if difference.length() < blurRadius:
			velocities[i] += difference.normalized() * (blurRadius - difference.length()) * pressureStrength * pressureStrength
			result += -difference.normalized() * (blurRadius - difference.length()) * pressureStrength * pressureStrength
		#elif difference.length() < blurRadius * 2:
		#	result += difference.normalized() * (blurRadius - difference.length()) * pressureStrength * pressureStrength
		#if difference.length() < blurRadius * 1.25:
			#likelyParticles[index].append(i)
	var mouse = get_global_mouse_position() - positions[index]
	if mouse.length() < blurRadius * 2:
		result += -mouse.normalized() * (blurRadius * 2 - mouse.length()) * pressureStrength * 20
	return result

func resolveCollisions(index) -> void:
	var halfBounds = bounds/2 - Vector2.ONE * particleRadius
	var pos = positions[index] - bounds/2
	
	if abs(pos.x) > halfBounds.x:
		positions[index].x = halfBounds.x * sign(pos.x) + bounds.x /2
		velocities[index].x *= -1 
	if abs(pos.y) > halfBounds.y:
		positions[index].y = halfBounds.y * sign(pos.y) + bounds.y /2
		velocities[index].y *= -1 

func _process(delta):
	
	if particleCount < 500:
		makeParticle()
		particleCount += 1
	
	for i in range(particleCount):

		velocities[i] += gravity
		velocities[i] += getDensityVector(i)
		velocities[i] *= collisionDamping
		velocities[i] += gravity * 0.3
	for i in range(particleCount):
		positions[i] += velocities[i]
	for i in range(particleCount):
		resolveCollisions(i)
	queue_redraw()
