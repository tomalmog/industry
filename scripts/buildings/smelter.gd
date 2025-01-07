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
	ItemManager.delete_item(item)
	
	var new_item = ItemManager.spawn_item(item.type + 1, ItemManager.MOVABLE)
	new_item.spawn_at_building(self)
	
	tick_counter = 0
	
func _run_tick():
	
	
	if stored_item:
		stored_item.set_state(ItemManager.MOVABLE)
	pass
	
	#if stored_item:
		#print('test complete')
		#stored_item.visible = false
