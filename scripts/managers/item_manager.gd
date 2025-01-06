extends Node

@export var items: Array[Item] = []  # List of all items in the game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	
	pass

# Function to handle all items' movement every tick
func _on_tick():
	var visited = {}
	
	for item in items:
		item.is_moving = false
		
		if not visited.has(item): 
			var stack = [item]  # Stack to process items iteratively
			#var to_move = []  # List of items to move this tick
			var chain = []

			# Perform the DFS to check which items can move
			while stack.size() > 0:
				var current_item = stack.pop_back()
				
				if visited.has(current_item):
					continue
					
				# Get the current belt the item is on
				var belt = current_item.stored_by
				
				if belt:
					# Get the next belt position based on the belt's direction
					var next_pos = belt.get_next()
					var next_belt = BuildingManager.get_building(next_pos)
					
					chain.push_back([current_item, next_pos])
					visited[current_item] = true
					
					if next_belt == null:
						break
										
					# Check if the next belt can accept the item
					if next_belt and next_belt.is_empty():
						print("chain works ", chain.size())
						for kvp in chain:
							move_item_to_next_tile(kvp[0], kvp[1])
							

# Function to actually move the item to the next belt
func move_item_to_next_tile(item: Item, next_pos: Vector2) -> void:
	var next_belt = BuildingManager.get_building(next_pos)
	
	WorldManager.move_stored_item(item.stored_by, next_belt)
	
# Function to spawn an item
func spawn_item(type: int) -> Node:
	
	var item_scene = preload("res://scenes/items/item.tscn")
	var new_item = item_scene.instantiate()
	
	items.append(new_item)
	WorldManager.world.add_child(new_item)
	return new_item
