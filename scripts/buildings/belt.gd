extends "res://scripts/building.gd"

# Properties
@export var speed: float = 2.0  # Speed at which items move on the belt

func _ready() -> void:
	type = BuildData.BELT_ID
	# Ensure direction is normalized (e.g., Vector2.RIGHT becomes (1, 0))
	direction = direction.normalized()  # probably can remove

func update_state(delta: float):
	"""
	Update the belt logic to move the stored item to the next tile if possible.
	"""
	if stored_item:
		var target_position = tilemap_pos + direction
		if can_move_to(target_position):
			move_item_to_next_tile(target_position)

func can_move_to(target_position: Vector2) -> bool:
	"""
	Check if the belt can move the stored item to the target position.
	"""
	# Use GridManager to get data about the next tile (assumes GridManager exists in your game)
	var target_tile = WorldManager.get_tile(target_position)
	
	if target_tile and target_tile.is_empty():
		return true
	return false
		
	
	
	
	#var target_tile_data = WorldManager.get_tile(target_position)
	#if target_tile_data and target_tile_data.has("instance"):
		#var target_instance = target_tile_data["instance"]
		#if target_instance and target_instance.can_accept_item():
			#return true
	#return false

func move_item_to_next_tile(target_position: Vector2) -> void:
	"""
	Moves the stored item to the next tile in the belt's direction.
	"""
	
	var next_tile = WorldManager.get_tile(target_position)
	next_tile.stored_item = stored_item;
	next_tile.stored_item.move(next_tile.position)
	
	stored_item = null;
	
	
	
	#
	#if stored_item:
		#var next_tile = WorldManager.get_tile(target_position)
		#if next_tile and next_tile_data["instance"]:
			#var next_instance = next_tile_data["instance"]
			#if next_instance.add_item(stored_item):
				#stored_item = null  # Clear the belt's stored item once moved

# Add an item to the belt
func interact(item: Node) -> void:
	"""
	Adds an item to the belt if it's empty.
	"""
	if is_empty():
		add_item(item)
		item.global_position = global_position  # Place the item visually on the belt

# Check if the belt can accept an item
func can_accept_item() -> bool:
	"""
	Returns true if the belt can accept an item (i.e., it is currently empty).
	"""
	return is_empty()

func custom_behavior(delta: float) -> void:
	"""
	Optional: Add any custom belt-specific logic here.
	"""
	pass
