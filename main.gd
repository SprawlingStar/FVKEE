extends Node2D

@export_category("Particle Draw Settings")
@export var particleColor : Color = Color.LIGHT_BLUE
@export_range(1,3.5,0.1) var particleRadius : float = 0.3
@export var drawParticles : bool = true

@export_category("Physics Variables")
@export_range(-10,10,0.1) var gravity := 9.8
@export_range(0,1,0.01) var collisionDamping = 0.7

@export_category("Setup")
@export var numParticles := 100
@export var particleSpacingPX = 10.0
@export var startPos : Vector2 = bounds/2 * 0.85

const bounds : Vector2 = Vector2(115,64)

var positions = []
var velocities = []

func _ready():
	for i in range(sqrt(numParticles)):
		for j in range(sqrt(numParticles)):
			positions.append(startPos + Vector2(i,j) * particleSpacingPX)
	
	for i in range(numParticles):
		velocities.append(Vector2.ZERO)

func _draw():
	if not drawParticles:
		return
	for pos in positions:
		draw_circle(pos,particleRadius,particleColor)
		
func _process(delta):
	for i in range(len(velocities)):
		velocities[i] += Vector2.DOWN * gravity * delta
	for i in range(len(positions)):
		positions[i] += velocities[i]
	for i in range(len(positions)): resolveCollisions(i)
	queue_redraw()

func resolveCollisions(index) -> void:
	var halfBounds = bounds/2 - Vector2.ONE * particleRadius
	var pos = positions[index] - bounds/2
	
	if abs(pos.x) > halfBounds.x:
		positions[index].x = halfBounds.x * sign(pos.x) + bounds.x /2
		velocities[index].x *= -1 * collisionDamping
	if abs(pos.y) > halfBounds.y:
		positions[index].y = halfBounds.y * sign(pos.y) + bounds.y /2
		velocities[index].y *= -1 * collisionDamping
