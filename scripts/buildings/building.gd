# Building.gd
extends Node2D
class_name Building


# Base Building Class - Abstract Class
# Defines the general behavior and structure for all buildings.

# Properties
var type: int                               # type of building e.g 0: Smelter, 1: Harvester
var grid_position: Vector2                  # position on tilemap
var output_direction: Vector2 = Vector2.UP      # output_direction building is facing, default is up
var stored_item: Item = null                # reference to the item that is currently stored by the building

# defined in initialization of building
var inputs = {}
var operation_interval: int 
var operation_intervals
var tick_counter: int = 0

func upgrade_building():
	operation_interval = operation_intervals[UpgradeManager.get_building_level(self.type)]

# Called when the node enters the scene tree for the first time
func initialize(rotation: int):
	pass

func get_next():
	return grid_position + output_direction
	
func can_accept_item(item: Item, input_direction: Vector2):
	return is_empty()

func is_empty() -> bool:
	return stored_item == null
	
func input_item():
	pass

func get_type():
	return type
	
func get_pos():
	return type
	
func get_direction():
	return output_direction
	
func get_stored_item():
	return stored_item

# Handle custom interactions per building type (to be implemented in subclasses)
func _on_tick():
	tick_counter += 1
	
	if tick_counter >= operation_interval:
		_run_tick()
		tick_counter = 0
	pass

func _run_tick():
	pass
