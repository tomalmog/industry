extends Building

class_name Trash

# Called when the node enters the scene tree for the first time.
func initialize():
	type = BuildData.TRASH_ID
	pass
	
	
func input_item():
	ItemManager.delete_item(stored_item)
