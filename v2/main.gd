extends Node2D

@export_category("Particle Draw Settings")
@export var particleColor : Color = Color.LIGHT_BLUE
@export_range(0,3.5,0.1) var particleRadius : float = 0.3
@export var drawParticles : bool = true


@export_category("Physics Variables")
@export_range(-10,10,0.1) var gravity := 9.8
@export_range(0,1,0.01) var collisionDamping = 0.7
@export var smoothingRadius : float = 0.5 #DIVIDE DISTANCE BY BOUNDS
@export var mass := 1.0
@export var targetDensity = 1.0
@export var pressureMultiplier = 1.0

@export_category("Setup")
@export var numParticles := 100
@export var particleSpacingPX = Vector2(10,10)
@export var startPos : Vector2 = bounds/2 * 0.85

const bounds : Vector2 = Vector2(115,64) /2

var volume = PI * pow(smoothingRadius,8) /4

var positions = []
var velocities = []
var values = []
var densities = []

func _ready():
	#for i in range(sqrt(numParticles)):
		#for j in range(sqrt(numParticles)):
			#positions.append(startPos + Vector2(i,j) * particleSpacingPX)
			#velocities.append(Vector2.ZERO)
			#values.append(exampleFunction(positions[i] / bounds * 4))
	
	for i in range(numParticles):
		positions.append(Vector2(randf() * bounds.x, randf() * bounds.y))
		velocities.append(Vector2.ZERO)
		#values.append(exampleFunction(positions[i] / bounds * 4))
	


func exampleFunction(pos : Vector2):
	return cos(pos.y -3 + sin(pos.x))

func _draw():
	if not drawParticles:
		return

	
	for pos in positions:
		draw_circle(pos,particleRadius,particleColor)
		#var grad = calculatePropertyGradient(pos)
		#grad.x *= -1
		#grad += pos
		#draw_line(pos,grad,particleColor)
		#draw_circle(grad,particleRadius,Color.RED)
		
func _process(delta):
	$Visualizer.update()
	

	
	for i in range(len(velocities)):
		velocities[i] += Vector2.DOWN * gravity * delta
	
	densities = []
	for pos in positions:
		densities.append(densityAtPoint(pos))	
	
	for i in range(len(velocities)):
		var pressureForce = calculatePropertyGradient(positions[i])
		var pressureAcceration = pressureForce / densities[i]
		velocities[i] = pressureAcceration * delta
	
	for i in range(len(positions)):
		positions[i] += velocities[i]
	for i in range(len(positions)): resolveCollisions(i)
	
	queue_redraw()

const stepSize = 0.001
func densityToPressure(density):
	var error = density - targetDensity
	var pressure = error * pressureMultiplier
	return pressure
func calculatePropertyGradient(point : Vector2) -> Vector2:
	
	#var p = calculateProperty(point)
	#var deltaX = calculateProperty(point + Vector2.RIGHT * stepSize) - p
	#var deltaY = calculateProperty(point + Vector2.UP * stepSize) - p
	#return Vector2(deltaX,deltaY)/stepSize
	var propertyGrad = Vector2.ZERO
	
	for i in range(numParticles):
		var dst = (positions[i] - point).length()
		if dst == 0:
			continue
		var dir = (positions[i] - point) / dst
		var slope = smoothingFunctionDerivative(dst / bounds.length())
		var density = densities[i]
		var f = densityToPressure(density)
		propertyGrad += f * dir * slope * mass / density
	return propertyGrad

func resolveCollisions(index) -> void:
	var halfBounds = bounds/2 - Vector2.ONE * particleRadius
	var pos = positions[index] - bounds/2
	
	if abs(pos.x) > halfBounds.x:
		positions[index].x = halfBounds.x * sign(pos.x) + bounds.x /2
		velocities[index].x *= -1 * collisionDamping
	if abs(pos.y) > halfBounds.y:
		positions[index].y = halfBounds.y * sign(pos.y) + bounds.y /2
		velocities[index].y *= -1 * collisionDamping

func smoothingFunction(dst) -> float:

	var value : float = max(0, smoothingRadius * smoothingRadius - dst * dst)
	return value * value * value / volume

func smoothingFunctionDerivative(dst) -> float:
	if dst >= smoothingRadius: return 0
	var f = smoothingRadius * smoothingRadius - dst * dst
	var s = -24 / (volume*4)
	return s * dst * f * f

func densityAtPoint(point : Vector2) -> float:
	var density = 0
	
	for pos in positions:
		var dst = (pos - point).length()
		var influence = smoothingFunction(dst / bounds.length())
		density += mass * influence
	return density

func calculateProperty(point : Vector2) -> float:
	var property = 0.0
	
	for i in range(numParticles):
		var dst = (positions[i] - point).length()
		var influence = smoothingFunction(dst / bounds.length())
		var density = densities[i]
		property += exampleFunction(point) * influence * mass / density
	return property
