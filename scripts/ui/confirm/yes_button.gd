extends Button

# Pre: none
# Post: none
# Description: connects clear game function to self.pressed
func _ready():
	pressed.connect(clear_game)

# Pre: none
# Post: none
# Description: clears all game data and reloads world
func clear_game():
	# clear save data
	SaveDataManager.clear_save_data()
	
	# delete any existing items
	for item in ItemManager.get_items():
		if item != null:
			item.queue_free()
	
	# reset all managers
	ResourceManager._ready()
	UpgradeManager._ready()
	BuildingManager._ready()
	ItemManager._ready()
	InventoryManager._ready()
	
	# reload scene
	get_tree().reload_current_scene()
	
	# hide the confirmation panel
	get_parent().hide()
	
	# play button clicked sound effect
	AudioManager.play_button_click_sound()
