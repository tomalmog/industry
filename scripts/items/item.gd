# Author: Tom Almog
# File Name: item.gd
# Project Name: Industry
# Creation Date: 1/10/2025
# Modified Date: 1/14/2025
# Description: base class for all items in the game, containing key information like item type, texture, and associated building
extends Node2D

class_name Item

# properties
@export var texture: Texture2D
@export var texture_scale: float = 0.75
@export var type: int

# track building that stores this item
var stored_by: Building = null  

# variables used to help with smooth movement between buildings
var was_moved: bool = false
var is_moving: bool = false
var output_direction: Vector2 = Vector2.ZERO

# pre: none
# post: none
# description: initializes the item when it enters the scene tree
func _ready():
	# sets visibilty layer to be above the buildings, and initially sets item to invisible before it has been moved
	z_index = 1
	visible = false

# pre: delta is the time elapsed since the last frame
# post: none
# description: updates the item's state and movement
func _process(delta: float):
	# sets moved state to false, used in itemmanager to control movements
	was_moved = false
	
	# if associated building has been deleted, remove self from world
	if stored_by == null:
		queue_free()
	else:
		stored_by.set_stored_item(self)
	
	# if item is moving, smoothly move it between two buildings using delta 
	if is_moving:
		var distance_per_second = WorldManager.TILE_SIZE * WorldManager.TICKS_PER_SECOND
		var movement = output_direction * distance_per_second * delta
		position += movement

# pre: building is the target building to move the item to
# post: none
# description: moves the item to the building
func move_to_building(building: Building):
	# sets building's stored item to self
	building.set_stored_item(self)
	
	# sets movement variables
	is_moving = true
	output_direction = stored_by.get_direction()
	
	# sets stored_by to building
	stored_by = building

# pre: building is the target building to spawn the item at
# post: the item is spawned at the building
# description: spawns the item at the building's position
func spawn_at_building(building: Building):
	# sets building's stored item to self
	building.set_stored_item(self)
	stored_by = building
	
	# updates position and movement direction
	position = building.position
	output_direction = stored_by.get_direction()

# pre: none
# post: none
# description: custom rendering for the item 
func _draw():
	# if a texture exists, draw
	if texture:
		# draw a scaled version of the item
		var texture_size = texture.get_size()
		var new_size = texture_size * texture_scale

		draw_texture_rect(texture, Rect2((texture_size - new_size) / 2, new_size), false)

# pre: none
# post: return type
# description: returns the type of the item
func get_type():
	return type

# pre: new_type is the desired new type of the item
# post: none
# description: sets the new type of the item
func set_type(new_type: bool):
	type = new_type

# pre: visibility is the desired visibility of the item
# post: none
# description: sets the visibility of the item
func set_visibility(visibility: bool):
	visible = visibility

# pre: none
# post: return visibility status
# description: returns whether the item is visible
func get_visibility():
	return visible
	
# pre: new_is_moving is what is_moving will be set to
# post: none
# description: sets whether or not the item is moving
func set_is_moving(new_is_moving: bool):
	is_moving = new_is_moving
	
# pre: new_was_moved is a valid boolean value
# post: none
# description: sets the was_moved property to the specified value
func set_was_moved(new_was_moved):
	was_moved = new_was_moved

# pre: none
# post: returns the current value of the was_moved property
# description: gets the current value of the was_moved property.
func get_was_moved():
	return was_moved
	
# pre: none
# post: returns the building that currently stores the item
# description: Retrieves the building that is currently storing the item.
func get_stored_by():
	return stored_by

# pre: building is a valid Building object
# post: none
# description: Updates the building that stores the item.
func set_stored_by(building: Building):
	stored_by = building
