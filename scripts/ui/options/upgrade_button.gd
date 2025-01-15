extends TextureButton

# Pre: none
# Post: none
# Description: connects the button's pressed signal to open the upgrades scene
func _ready():
	# connect the button's pressed signal to the open_upgrades function
	pressed.connect(open_upgrades)

# Pre: none
# Post: none
# Description: handles loading and switching to the upgrades scene
func open_upgrades():
	# save the current camera settings in the world to preserve its state
	get_node("/root/World/Camera").save_camera()
	
	# load the upgrades scene to prepare for the scene transition
	var upgrades_scene = preload("res://scenes/upgrades.tscn")
	
	# change the current scene to the preloaded upgrades scene
	get_tree().change_scene_to_packed(upgrades_scene)
	
	# update the game state to reflect that the upgrades screen is active
	WorldManager.set_state(WorldManager.UPGRADE_STATE)
	
	# iterate through all items managed by the ItemManager and set their visibility to false
	# this ensures that items in the world are hidden while the upgrades scene is active
	for item in ItemManager.get_items():
		item.set_visibility(false)
