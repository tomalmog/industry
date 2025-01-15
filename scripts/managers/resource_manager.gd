# Author: Tom Almog
# File Name: resource_manager.gd
# Project Name: Industry
# Creation Date: 1/11/2025
# Modified Date: 1/14/2025
# Description: manages resource nodes
extends Node

# dictionary to store all the resource nodes
var resources: Dictionary

# pre: none
# post: none
# description: This function is called when the node enters the scene tree for the first time, it defines the resources dictionary
func _ready():
	resources = {}

# pre: none
# post: returns the resources dictionary.
# description: This function returns the entire resources dictionary 
func get_resources():
	return resources

# pre: grid_position is a valid Vector2.
# post: returns the resource at the specified grid position if it exists, or -1 if no resource is found.
# description: This function retrieves the resource stored at a specific grid position, and an error code if there is no resource at that point
func get_resource(grid_position: Vector2):
	if resources.has(grid_position):
		return resources[grid_position]
	return -1

# pre: grid_position is a valid Vector2, type is an integer representing the resource type.
# post: none
# description: This function stores the given resource type at the specified grid position in the 'resources' dictionary.
func set_resource(grid_position: Vector2, type: int):
	resources[grid_position] = type
