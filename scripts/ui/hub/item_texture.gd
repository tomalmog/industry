extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_quest_item()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_quest_item():
	var item_scene = ItemManager.item_instances[InventoryManager.get_quest_item()].instantiate()
	
	texture = item_scene.texture
