

class_name Item

extends Node2D

# Properties
@export var texture: Texture2D
@export var texture_scale: float = 0.75

@export var type: int
var state: int = 0  # Use this to define the current state of the item (e.g., idle, moving)

var stored_by: Building = null  # Building or other system that holds the item
var was_moved: bool = false

var is_moving: bool = false
var output_direction: Vector2 = Vector2.ZERO



# Called when the node enters the scene tree for the first time
func _ready():
	# Set the texture to the Sprite nod
	z_index = 1
	visible = false
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
		var movement = output_direction * distance_per_second * delta
		position += movement
		

		
		
	
# Move the item to a new position
func move(new_position: Vector2):
	position = new_position
	global_position = position
	
func move_to_building(building: Building):
	building.stored_item = self
	is_moving = true
	output_direction = stored_by.output_direction
	
	stored_by = building
	
func spawn_at_building(building: Building):
	building.stored_item = self
	stored_by = building
	
	position = building.position
	
	output_direction = stored_by.output_direction
	

# Draw the item (if needed for custom rendering)
func _draw():
	if texture:
		var texture_size = texture.get_size()
		var new_size = texture_size * texture_scale
		
		draw_texture_rect(texture, Rect2((texture_size - new_size) / 2, new_size), false)

# Update the item's logic (called manually or via another system)
func update_item(delta: float):
	# Perform any updates required for the item's behavior
	pass
	
func get_state():
	return state
	
func set_state(new_state: int):
	state = new_state
	
func get_type():
	return type
	
func set_type(new_type: int):
	type = new_type
