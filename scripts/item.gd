# item.gd
extends Node2D

# Attributes
@export var texture
@export var type
@export var id


var state
var stored_by  # Will hold the reference to the storing building


position: Vector2 = Vector2.ZERO

# Initialization
func _ready():
	# Set default values or initialize as needed
	stored_by = null

# Methods
func move(new_position: Vector2) -> void:
	"""
	Moves the item to a new position.
	"""
	position = new_position
	global_position = new_position

func interact(building: Node) -> void:
	"""
	Define item interactions with a building.
	Specific behavior depends on the building type.
	"""
	if building and building.has_method("interact"):
		building.interact(self)

func draw() -> void:
	"""
	Draws the item's texture at its current position.
	"""
	if texture:
		draw_texture(texture, Vector2.ZERO)

# Called every frame to handle rendering
func _draw():
	draw()

func _process(delta: float) -> void:
	"""
	Continuously update item behavior if needed.
	"""
	pass
