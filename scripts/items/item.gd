

class_name Item

extends Node2D

# Properties
@export var texture: Texture2D
@export var type: int
@export var id: int
@export var state: int = 0  # Use this to define the current state of the item (e.g., idle, moving)
@export var speed: float = 200

var stored_by: Building = null  # Building or other system that holds the item
var was_moved: bool = false

var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var direction: Vector2 = Vector2.ZERO



# Called when the node enters the scene tree for the first time
func _ready():
	# Set the texture to the Sprite nod
	z_index = 1
	pass
	
func _process(delta: float) -> void:
	was_moved = false
	
	if stored_by == null:
		queue_free()
		pass
	else:
		stored_by.stored_item = self
		
	if is_moving:
		var distance_per_second = WorldManager.tile_size * WorldManager.ticks_per_second
		var movement = stored_by.direction * distance_per_second * delta
		position += movement
		#move_towards_target(delta)
	


# Move the item to a new position
func move(new_position: Vector2):
	position = new_position
	global_position = position
	
func move_to(new_position: Vector2) -> void:
	target_position = new_position
	is_moving = true
	
func move_to_building(new_building: Node):
	new_building.stored_item = self
	#is_moving = true
	
	stored_by = new_building
	position = new_building.position
	

# Draw the item (if needed for custom rendering)
func _draw():
	if texture:
		draw_texture(texture, Vector2(0, 0))
	draw_circle(Vector2(0, 0), 5, Color(1, 0, 0))

# Update the item's logic (called manually or via another system)
func update_item(delta: float):
	# Perform any updates required for the item's behavior
	pass


func move_towards_target(delta: float) -> void:
	# The time passed between ticks, adjusted by delta time
	var time_per_tick = 1.0 / WorldManager.ticks_per_second  # Time per tick in seconds
	var distance_per_tick = speed * time_per_tick  # How far the item moves per tick (speed * time)

	# Calculate the current distance to the target
	var current_distance = 64

	# If the item is close enough to the target, snap it to the target and stop
	if current_distance <= distance_per_tick:
		position = target_position  # Snap to target position
		is_moving = false  # Stop moving
		# Optionally, handle any actions when the item reaches the target
	else:
		# Move the item towards the target position
		position += direction * distance_per_tick
