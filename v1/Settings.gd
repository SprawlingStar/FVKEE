extends Node
class_name Settings

@export_category("Particle Draw Settings")
@export_range(0,35,0.1) var particleRadius = 3
@export_color_no_alpha var particleBaseColor = Color.ROYAL_BLUE

@export_category("Setup Settings")
@export var numParticles : int = 100
@export var particleSpacing = 10

@export_category("Physical Settings")
@export_range(-10,10,0.1) var gravity = 9.8
@export var Bounds : Vector2 = Vector2(1152,648)
@export_range(0,1,0.01) var collisionDamping = 0.7
@export var ParticleMass := 1.0
@export var smoothingRadius : float = 0.5

