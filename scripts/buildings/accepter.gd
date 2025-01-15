# Author: Tom Almog
# File Name: accepter.gd
# Project Name: Industry
# Creation Date: 1/10/2025
# Modified Date: 1/14/2025
# Description: defines the accepter building type, which consumes items and adds them to the inventory
extends Building

class_name Accepter

# pre: rotation is the initial rotation of the building
# post: none
# description: initializes the accepter building, setting its type to accepter
func initialize(rotation: int):
	type = BuildData.ACCEPTER_ID

# pre: none
# post: none
# description: handles the input of an item by adding it to the inventory and removing it from the game world
func input_item():
	InventoryManager.add_to_inventory(stored_item)
	ItemManager.delete_item(stored_item)
