extends Building

class_name Smelter

var inputType = 0 #takes in ores
var outputType = 1 #outputs nugget


# Called when the node enters the scene tree for the first time.
func initialize():
	type = BuildData.SMELTER_ID
	operation_interval = 8
	pass
	
	
func can_accept_item(item: Item) -> bool:
	if is_empty() && item.type % 10 == 0:
		return true
	return false
	
func input_item(item: Item):
	item = ItemManager.spawn_item(item.type + 1, ItemManager.IMMOVABLE)
	tick_counter = 0
	
	
	#ItemManager.delete_item(item)
	
	#print(item.type)
	#var new_item = ItemManager.spawn_item(item.type + 1, ItemManager.IMMOVABLE)
	#new_item.spawn_at_building(self)
	#
	#new_item.was_moved = true
	#stored_item = new_item
	#
	#
	#tick_counter = 0
	
	#if !stored_item:
		#var item = ItemManager.spawn_item(resource_type, ItemManager.MOVABLE)
		#item.spawn_at_building(self)
		#
		#stored_item = item
	
func _run_tick():
	
	if stored_item:
		stored_item.set_state(ItemManager.MOVABLE)
	pass
	
	#if stored_item:
		#print('test complete')
		#stored_item.visible = false
