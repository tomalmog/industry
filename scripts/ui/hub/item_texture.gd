extends TextureRect

# Pre: none
# Post: none
# Description: updates based on bquest item
func _ready():
	update_quest_item()

# Pre: none
# Post: none
# Description: update texture based on current quest item
func update_quest_item():
	var item_scene = ItemManager.get_item_instances()[InventoryManager.get_quest_item()].instantiate()
	texture = item_scene.texture
