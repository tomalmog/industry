# Building.gd
extends Node2D
class_name Building


# Base Building Class - Abstract Class
# Defines the general behavior and structure for all buildings.

# Properties
@export var type: int                            # type of building e.g 0: Smelter, 1: Harvester
@export var grid_position: Vector2                 # position on tilemap
@export var direction: Vector2 = Vector2.UP      # direction building is facing, default is up
@export var stored_item: Item = null             # reference to the item that is currently stored by the building 
@export var moving_in_item: Node = null

# Called when the node enters the scene tree for the first time
func _ready():
	pass

# Polymorphic methods to be overridden by derived classes
func move():
	var next_building = BuildingManager.get_building(get_next())
	
	stored_item.stored_by = next_building
	next_building.moving_in_item = stored_item
	
	stored_item = null
	pass  # To be implemented in child classes
	
func get_next():
	return grid_position + direction

# Interact with an item
func interact(item: Node):
	pass  # To be implemented in child classes (e.g., crafting, processing)

# Update the state of the building
func update_state(delta: float):
	pass  # Optional: Add logic for timers or state transitions

func is_empty() -> bool:
	return not stored_item

# Add an item to the building's inventory
func add_item(item: Node) -> bool:
	if is_empty():
		stored_item = item
		item.stored_by = self # maybe dont need this, items can be unaware of their owners. if needed, add this item stuff everywhere
		return true
	return false

# Remove an item from the inventory
func remove_item(item: Node) -> bool:
	if !is_empty():
		stored_item = null
		return true;
	return false
	
# Handle custom interactions per building type (to be implemented in subclasses)
func custom_behavior(delta: float):
	pass
