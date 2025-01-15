extends Label

# Pre: none
# Post: none
# Description: updates based on quest item
func _ready():
	update_quest_item()
	
# Pre: none
# Post: none
# Description: gets current quest item and sets the label text to item name
func update_quest_item():
	var item_scene = ItemManager.get_item_instances()[InventoryManager.get_quest_item()].instantiate()
	text = item_scene.name
