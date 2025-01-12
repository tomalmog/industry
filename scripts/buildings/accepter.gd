extends Building

class_name Accepter

func initialize(rotation: int):
	type = BuildData.ACCEPTER_ID
	pass
	
func input_item():
	InventoryManager.add_to_inventory(stored_item)
	ItemManager.delete_item(stored_item)
