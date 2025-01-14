extends Control

# Upgrade-related variables
var upgrade_list
var inventory
var upgrade_requirements

var upgrade_icon

func _ready():
	# Reference the UpgradeList node and get the inventory
	upgrade_list = $"Panel/ScrollContainer/UpgradeList"
	inventory = InventoryManager.get_inventory()
	upgrade_requirements = UpgradeManager.get_upgrade_requirements()
	
	upgrade_icon = preload("res://assets/icons/upgrade_icon.png")

	# Populate the upgrades list
	populate_upgrade_list()


func populate_upgrade_list():
	# Clear the upgrade list
	for child in upgrade_list.get_children():
		child.queue_free()
		
	# Iterate through all quests
	for building in upgrade_requirements:
		
		var current_level = UpgradeManager.get_building_level(building)
		
		# Create a panel to contain the upgrade entry
		var upgrade_panel = Panel.new()
		upgrade_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Stretch horizontally
		upgrade_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		upgrade_panel.custom_minimum_size = Vector2(0, 64)  # Minimum height for visibility
		upgrade_panel.modulate = Color(0.9, 0.9, 0.9)  # Light gray background by default

		# Create a container for the upgrade entry inside the panel
		var upgrade_container = HBoxContainer.new()
		upgrade_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		upgrade_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		upgrade_container.add_theme_constant_override("separation", 20)  # Optional: Adjust spacing between children

		# Building icon
		var build_icon = TextureRect.new()
		build_icon.texture = BuildData.get_building_icon(building)
		build_icon.custom_minimum_size = Vector2(64, 64)
		build_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		upgrade_container.add_child(build_icon)

		var divider = Panel.new()
		divider.custom_minimum_size = Vector2(10, 0)  # Set width to 10px for the vertical break (adjust as needed)
		divider.size = Vector2(10, 0)  # Ensure it's 10px wide
		divider.modulate = Color(0.5, 0.5, 0.5)  # Optional: Set color for the divider line
		upgrade_container.add_child(divider)
		
		
		
		# Add hover highlight effect to the panel
		upgrade_panel.mouse_entered.connect(func() -> void: _on_hover_start(upgrade_panel))
		upgrade_panel.mouse_exited.connect(func() -> void: _on_hover_end(upgrade_panel))

		# Add the container to the panel
		upgrade_panel.add_child(upgrade_container)

		# Add the panel to the upgrade list
		upgrade_list.add_child(upgrade_panel)
		
		if current_level < 2:
			var item_id = upgrade_requirements[building][current_level][0]
			var required = upgrade_requirements[building][current_level][1]
			var collected = inventory.get(item_id, 0)  # Safely get collected items or default to 0

			# Item icon
			var item_icon = TextureRect.new()
			item_icon.texture = ItemManager.item_instances[item_id].instantiate().texture
			item_icon.custom_minimum_size = Vector2(64, 64)
			item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			upgrade_container.add_child(item_icon)

			# Progress bar and label
			var progress_container = VBoxContainer.new()
			progress_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_container.custom_minimum_size = Vector2(120, 64)

			var progress_bar = ProgressBar.new()
			progress_bar.max_value = required
			progress_bar.value = collected
			progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_container.add_child(progress_bar)

			var progress_label = Label.new()
			progress_label.text = "%d / %d" % [collected, required]
			progress_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			progress_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_label.horizontal_alignment = Label.PRESET_CENTER
			progress_container.add_child(progress_label)

			upgrade_container.add_child(progress_container)

			# Add Spacer control to push button to the right
			var spacer = Control.new()
			spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Spacer will push the button to the right
			upgrade_container.add_child(spacer)

			# upgrade button
			var upgrade_button = Button.new()
			upgrade_button.text = "UPGRADE"
			upgrade_button.size_flags_horizontal = Control.SIZE_SHRINK_END  # Align button to the right
			upgrade_button.disabled = collected < required
			upgrade_button.pressed.connect(func() -> void: _on_claim_button_pressed(item_id, building, required))
		
			upgrade_container.add_child(upgrade_button)
		
		else:
			var label = Label.new()
			label.text = "MAX LEVEL"
			upgrade_container.add_child(label)
			


# Highlight the panel when hovered
func _on_hover_start(panel: Panel):
	panel.modulate = Color(0.8, 0.8, 1)  # Change color when hovered (highlighted)

func _on_hover_end(panel: Panel):
	panel.modulate = Color(0.9, 0.9, 0.9)  # Reset to original color when not hovered


func _on_claim_button_pressed(item_id: int, building, required: int):
	# Check if the player has enough items
	if inventory.has(item_id) and inventory[item_id] >= required:
		# Remove the required items from the inventory
		inventory[item_id] -= required

		# Mark the quest as completed
		UpgradeManager.upgrade_building(building)

		# Reload the upgrade list
		populate_upgrade_list()
