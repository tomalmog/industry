extends Node2D

# Properties
@export var texture: Texture2D
@export var type: int
@export var id: int
@export var state: int = 0  # Use this to define the current state of the item (e.g., idle, moving)
@export var speed: float = 200

var stored_by: Node = null  # Building or other system that holds the item
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false


# Called when the node enters the scene tree for the first time
func _ready():
	# Set the texture to the Sprite nod
	z_index = 1
	pass
	
func _process(delta: float) -> void:
	
	if stored_by:
		position = stored_by.position
	else:
		print("error")

	
	if is_moving:
		var direction = (target_position - position).normalized()
		var distance = speed * delta  # Calculate distance to move this frame

		if position.distance_to(target_position) <= distance:
			# Snap to the target if close enough
			position = target_position
			is_moving = false  # Stop moving
		else:
			# Move toward the target position
			position += direction * distance

# Move the item to a new position
func move(new_position: Vector2):
	position = new_position
	#global_position = position
	
func move_to(new_position: Vector2) -> void:
	target_position = new_position
	is_moving = true
	

func move_to_building(new_building: Node):
	position = new_building.position
	stored_by = new_building
	
	
	



# Draw the item (if needed for custom rendering)
func _draw():
	if texture:
		draw_texture(texture, position)
	draw_circle(global_position, 5, Color(1, 0, 0))

# Update the item's logic (called manually or via another system)
func update_item(delta: float):
	# Perform any updates required for the item's behavior
	pass


















## item.gd
#extends Node2D
#
## Attributes
#@export var texture: Texture2D = null
#@export var type: int
#@export var id: int
#var state: int = 0
#var stored_by: Node = null  # Will hold the reference to the storing building
#
## Initialization
#func _ready():
	## Set default values or initialize as needed
	#
	#position = Vector2.ZERO
	#
#
#
## Methods
#func move(new_position: Vector2) -> void:
	#"""
	#Moves the item to a new position.
	#"""
	#position = new_position
	#global_position = new_position
#
#func interact(building: Node) -> void:
	#"""
	#Define item interactions with a building.
	#Specific behavior depends on the building type.
	#"""
	#if building and building.has_method("interact"):
		#building.interact(self)
#
#func draw() -> void:
	#"""
	#Draws the item's texture at its current position.
	#"""
	#if texture:
		#draw_texture(texture, Vector2.ZERO)
#
## Called every frame to handle rendering
#func _draw():
	#draw()
#
#func _process(delta: float) -> void:
	#"""
	#Continuously update item behavior if needed.
	#"""
	#pass
