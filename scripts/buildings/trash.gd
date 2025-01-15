# Author: Tom Almog
# File Name: trash.gd
# Project Name: Industry
# Creation Date: 1/10/2025
# Modified Date: 1/14/2025
# Description: defines the trash building type, which discards items that have been inputted
extends Building

class_name Trash

# pre: rotation is the initial rotation of the trash building
# post: none
# description: initializes the trash building and sets its type to TRASH_ID
func initialize(rotation: int):
	type = BuildData.TRASH_ID
	
# pre: none
# post: none
# description: deletes the stored item when it is input to the trash building
func input_item():
	ItemManager.delete_item(stored_item)
	
# pre: item is the item being checked, input_direction is the direction from which the item is coming
# post: returns true, indicating that the trash building can accept any item
# description: returns true for any item, allowing the trash building to accept and delete any input
func can_accept_item(item: Item, input_direction: Vector2):
	return true
