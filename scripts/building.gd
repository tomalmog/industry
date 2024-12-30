# Building.gd
extends Node2D

# Base Building Class - Abstract Class
# Defines the general behavior and structure for all buildings.

# Properties
@export var type: int                            # type of building e.g 0: Smelter, 1: Harvester
@export var tilemap_pos: Vector2                 # position on tilemap
@export var direction: Vector2 = Vector2.UP      # direction building is facing, default is up
@export var stored_item: Node = null             # reference to the item that is currently stored by the building 

#@export var max_inventory_size: int = 10  # Maximum number of items the building can hold
#var inventory: Array = []               # Inventory system for storing items

# Called when the node enters the scene tree for the first time
func _ready():
	pass

# Move an item into or out of the building
# Polymorphic method to be overridden by derived classes
func move(item: Node):
	pass  # To be implemented in child classes

# Interact with an item
# Polymorphic method to be overridden by derived classes
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
