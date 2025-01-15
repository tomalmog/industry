extends TextureButton

# Pre: none
# Post: none
# Description: connects pressed signal to open inventory
func _ready():
	pressed.connect(open_inventory)

# Pre: none
# Post: none
# Description: opens inventory
func open_inventory():
	# load inventory scene
	var inventory_scene = preload("res://scenes/inventory.tscn")
	
	# save world camera settings
	get_node("/root/World/Camera").save_camera()
	
	# change scene to inventory scene, and set worldstate to inventory
	get_tree().change_scene_to_packed(inventory_scene)
	WorldManager.set_state(WorldManager.INVENTORY_STATE)
	
	# iterate through all items managed by the ItemManager and set their visibility to false
	# this ensures that items in the world are hidden while the upgrades scene is active
	for item in ItemManager.get_items():
		item.set_visibility(false)
