extends Control

# Upgrade-related variables
var upgrade_list
var inventory
var upgrade_requirements

func _ready():
	# Reference the UpgradeList node and get the inventory
	upgrade_list = $"Panel/ScrollContainer/UpgradeList"
	inventory = InventoryManager.get_inventory()
	upgrade_requirements = UpgradeManager.get_upgrade_requirements()

	# Populate the upgrades list
	populate_upgrade_list()

func populate_upgrade_list():
	# Clear the upgrade list
	for child in upgrade_list.get_children():
		child.queue_free()

	# Iterate through all quests
	for building in upgrade_requirements.keys():
		var current_level = UpgradeManager.get_building_level(building)
		var item_id = upgrade_requirements[building][current_level][0]
		var required = upgrade_requirements[building][current_level][1]
		var collected
		
		if inventory.has(item_id):
			collected = inventory[item_id]
		else:
			collected = 0

		# Create a container for the upgrade entry
		var upgrade_container = HBoxContainer.new()
		upgrade_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Configure size behavior

		# building icon
		var build_icon = TextureRect.new()
		build_icon.texture = BuildData.get_building_icon(building)
		print(build_icon.texture)
		build_icon.custom_minimum_size = Vector2(64, 64)  # Set minimum size for the icon
		upgrade_container.add_child(build_icon)

		# Item icon
		var item_icon = TextureRect.new()
		item_icon.texture = ItemManager.item_instances[item_id].instantiate().texture
		item_icon.custom_minimum_size = Vector2(64, 64)  # Set minimum size for the icon
		upgrade_container.add_child(item_icon)

		# Progress bar with collected/required text
		var progress_container = VBoxContainer.new()

		var progress_bar = ProgressBar.new()
		progress_bar.max_value = required
		progress_bar.value = collected
		progress_container.add_child(progress_bar)

		var progress_label = Label.new()
		progress_label.text = "%d / %d" % [collected, required]
		progress_container.add_child(progress_label)
		upgrade_container.add_child(progress_container) 

		# Claim button
		var claim_button = Button.new()
		claim_button.text = "Claim"
		claim_button.disabled = collected < required
		claim_button.pressed.connect(func() -> void: _on_claim_button_pressed(item_id, building, required))

		upgrade_container.add_child(claim_button)

		# Add a horizontal break (separator) between the upgrade entries
		var separator = Panel.new()
		separator.custom_minimum_size = Vector2(0, 10)  # Set the height of the separator (horizontal break)
		separator.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Make it expand horizontally
		upgrade_list.add_child(separator)  # Add the separator after each upgrade entry

		# Add hover highlight effect to the HBoxContainer
		# Add signals for hover detection
		upgrade_container.mouse_entered.connect(func() -> void: _on_hover_start(upgrade_container))
		upgrade_container.mouse_exited.connect(func() -> void: _on_hover_end(upgrade_container))
		#upgrade_container.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		#upgrade_container.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
		
		
		# Add the container to the upgrade list
		upgrade_list.add_child(upgrade_container)


# Highlight the HBoxContainer when hovered
func _on_hover_start(container: HBoxContainer):
	print('hovered')
	container.modulate = Color(0.5, 0.5, 1)  # Change color when hovered (highlighted)

func _on_hover_end(container: HBoxContainer):
	container.modulate = Color(1, 1, 1)  # Reset to original color when not hovered




func _on_claim_button_pressed(item_id: int, building, required: int):
	# Check if the player has enough items
	#var required = InventoryManager.quests[quest_index][1]
	if inventory.has(item_id) and inventory[item_id] >= required:
		# Remove the required items from the inventory
		inventory[item_id] -= required

		# Mark the quest as completed
		UpgradeManager.upgrade_building(building)

		# Reload the upgrade list
		populate_upgrade_list()
