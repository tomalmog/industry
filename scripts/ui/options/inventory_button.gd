extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pressed.connect(open_inventory)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_inventory():
	# Attempt to load and change to the inventory scene
	
	var inventory_scene = preload("res://scenes/inventory.tscn")
	
	get_node("/root/World/Camera").save_camera()
	
	get_tree().change_scene_to_packed(inventory_scene)
	WorldManager.set_state(WorldManager.INVENTORY_STATE)
	
	
	
	for item in ItemManager.items:
		item.set_visibility(false)
