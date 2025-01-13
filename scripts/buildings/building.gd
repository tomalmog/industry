# Building.gd
extends Node2D
class_name Building


# Base Building Class - Abstract Class
# Defines the general behavior and structure for all buildings.

# Properties
@export var type: int                              # type of building e.g 0: Smelter, 1: Harvester
@export var grid_position: Vector2                 # position on tilemap

var output_direction: Vector2 = Vector2.UP      # output_direction building is facing, default is up
var inputs = {}

var stored_item: Item = null             # reference to the item that is currently stored by the building

var inventory = {}


var operation_interval: int 
var tick_counter: int = 0
var state: int = 0

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

# Handle custom interactions per building type (to be implemented in subclasses)
func _on_tick():
	tick_counter += 1
	
	if tick_counter >= operation_interval:
		_run_tick()
		tick_counter = 0
	pass

func _run_tick():
	pass
