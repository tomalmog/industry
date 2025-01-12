extends Control

func _ready():
	# Populate inventory (example data)
	var inventory_items = { "Sword": 1, "Potion": 5, "Shield": 2 }
	var container = $VBoxContainer  # Adjust based on your scene structure
	
	for item_name in inventory_items.keys():
		var quantity = inventory_items[item_name]
		var label = Label.new()
		label.text = "%s: %d".format([item_name, quantity])
		container.add_child(label)
	
	var inventory = InventoryManager.get_inventory()
	
	for item in inventory:
		var quantity = inventory[item]
		var label = Label.new()
		
		label.text = "%s: %d" % [item, quantity]

	# Connect the back button
	$BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	# Go back to the main scene
	#var main_scene_path = ""
	get_tree().change_scene_to_file("res://scenes/main.tscn")
