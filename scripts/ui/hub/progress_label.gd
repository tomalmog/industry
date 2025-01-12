extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%d / %d" % [InventoryManager.get_inventory_count(InventoryManager.get_quest_item()), InventoryManager.get_quest_requirement()]
	pass

	
	
	
