extends Label

# Pre: delta is time passed since last call
# Post: none
# Description: updates progress label text based on quest
func _process(delta: float):
	text = "%d / %d" % [InventoryManager.get_inventory_count(InventoryManager.get_quest_item()), InventoryManager.get_quest_requirement()]
