extends Building

class_name Trash

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	type = BuildData.TRASH_ID
	pass
	
func input_item():
	ItemManager.delete_item(stored_item)
	
func can_accept_item(item: Item, input_direction: Vector2):
	return true
