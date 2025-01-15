extends ProgressBar

# Pre: delta is time passed since last call
# Post: none
# Description: update progress bar based on current quest progress
func _process(delta: float):
	value = float(InventoryManager.get_inventory_count(InventoryManager.get_quest_item())) / InventoryManager.get_quest_requirement() * 100
