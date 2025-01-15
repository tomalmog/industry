# Author: Tom Almog
# File Name: upgrades.gd
# Project Name: Industry
# Creation Date: 1/10/2025
# Modified Date: 1/14/2025
# Description: script for the upgrades control node, populates the list of currently available upgrades and generates visual nodes for them
extends Control

# Upgrade-related variables
var upgrade_list  # Reference to the list of upgrades
var inventory  # The player's inventory
var upgrade_requirements  # The required items for each upgrade
var upgrade_icon  # Icon for the upgrade

# Pre: none
# Post: none
# Description: initializes the upgrade list, inventory, and upgrade requirements
func _ready():
	# Reference the UpgradeList node and get the inventory
	upgrade_list = $"Panel/ScrollContainer/UpgradeList"
	inventory = InventoryManager.get_inventory()
	upgrade_requirements = UpgradeManager.get_upgrade_requirements()
	
	# Preload the upgrade icon texture
	upgrade_icon = preload("res://assets/icons/upgrade_icon.png")

	# Populate the upgrades list with upgrade options
	populate_upgrade_list()

# Pre: none
# Post: none
# Description: populates the upgrade list with available upgrades and progress bars
func populate_upgrade_list():
	# Clear the current upgrade list
	for child in upgrade_list.get_children():
		child.queue_free()
		
	# Iterate through all upgrade requirements
	for building in upgrade_requirements:
		# Get the current level of the building
		var current_level = UpgradeManager.get_building_level(building)
		
		# Create a new panel for each upgrade entry and set its properties
		var upgrade_panel = Panel.new()
		upgrade_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Stretch horizontally
		upgrade_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL # expand vertically
		upgrade_panel.custom_minimum_size = Vector2(0, 64)  # Minimum height for visibility
		upgrade_panel.modulate = Color(0.9, 0.9, 0.9)  # Light gray background by default

		# Create a container for the upgrade entry inside the panel and set properties
		var upgrade_container = HBoxContainer.new()
		upgrade_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		upgrade_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		upgrade_container.add_theme_constant_override("separation", 20)  # Adjust spacing between children

		# Add building icon and set properties, make building icon a child of upgrade_container
		var build_icon = TextureRect.new()
		build_icon.texture = BuildData.get_building_icon(building)
		build_icon.custom_minimum_size = Vector2(64, 64)
		build_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		upgrade_container.add_child(build_icon)

		# Add a divider for visual separation, divider is a child of upgrade_container
		var divider = Panel.new()
		divider.custom_minimum_size = Vector2(10, 0)  # Set width to 10px for the vertical break
		divider.size = Vector2(10, 0)  # Ensure it's 10px wide
		divider.modulate = Color(0.5, 0.5, 0.5) 
		upgrade_container.add_child(divider)
		
		# Add hover highlight effect to the panel
		upgrade_panel.mouse_entered.connect(func() -> void: on_hover_start(upgrade_panel))
		upgrade_panel.mouse_exited.connect(func() -> void: on_hover_end(upgrade_panel))

		# Add the upgrade_container to the panel
		upgrade_panel.add_child(upgrade_container)

		# Add the panel to the upgrade list
		upgrade_list.add_child(upgrade_panel)
		
		# if the building can still be upgraded, add information about the upgrade, if not, add a node that says MAX LEVEL
		if current_level < 2:
			# Get the current item id and required quantity for upgrade
			var item_id = upgrade_requirements[building][current_level][0]
			var required = upgrade_requirements[building][current_level][1]
			var collected = inventory.get(item_id, 0)  # safely get collected items or default to 0

			# Add item icon for required upgrade items and add it as child of upgrade_container
			var item_icon = TextureRect.new()
			item_icon.texture = ItemManager.get_item_instances()[item_id].instantiate().texture
			item_icon.custom_minimum_size = Vector2(64, 64)
			item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			upgrade_container.add_child(item_icon)

			# Add a progress container, bar, and label to show upgrade progress. Add them all as children of upgrade_container
			var progress_container = VBoxContainer.new()
			progress_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_container.custom_minimum_size = Vector2(120, 64)

			var progress_bar = ProgressBar.new()
			progress_bar.max_value = required
			progress_bar.value = collected
			progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_container.add_child(progress_bar)
			
			# create a new stylebox for the background
			var stylebox = StyleBoxFlat.new()
			stylebox.bg_color = Color("CF9474")  # set background color to brown / orange
			stylebox.set_corner_radius_all(8) #set corner radius 
			
			# attach to progress bar
			progress_bar.add_theme_stylebox_override("background", stylebox)

			var progress_label = Label.new()
			progress_label.text = "%d / %d" % [collected, required]
			progress_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			progress_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			progress_label.horizontal_alignment = Label.PRESET_CENTER
			progress_container.add_child(progress_label)
				
			upgrade_container.add_child(progress_container)

			# Add spacing through a control node, helps position the upgrade button
			var spacer = Control.new()
			spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Spacer will push the button to the right
			upgrade_container.add_child(spacer)

			# Add upgrade button, then make it child of upgrade_container
			var upgrade_button = Button.new()
			upgrade_button.text = "UPGRADE"
			upgrade_button.size_flags_horizontal = Control.SIZE_SHRINK_END  # Align button to the right
			upgrade_button.disabled = collected < required
			upgrade_button.pressed.connect(func() -> void: on_claim_button_pressed(item_id, building, required))
			upgrade_container.add_child(upgrade_button)
		
		else:
			# Add label to show that the building is at maximum level
			var label = Label.new()
			label.text = "MAX LEVEL"
			upgrade_container.add_child(label)

# Pre: panel is a valid Panel node
# Post: none
# Description: highlights the panel when hovered
func on_hover_start(panel: Panel):
	panel.modulate = Color(0.8, 0.8, 1)  # Change color when hovered (highlighted)

# Pre: panel is a valid Panel node
# Post: none
# Description: restores the panel's color when the hover ends
func on_hover_end(panel: Panel):
	panel.modulate = Color(0.9, 0.9, 0.9)  # Reset to original color when not hovered

# Pre: item_id is valid integer item id, building is a valid integer building id, required is the quantity of the item required for the upgrade
# Post: none
# Description: handles the logic when the upgrade button is pressed, checking for enough resources
func on_claim_button_pressed(item_id: int, building: int, required: int):
	# Check if the player has enough items for the upgrade
	if inventory.has(item_id) and inventory[item_id] >= required:
		# Remove the required items from the inventory
		inventory[item_id] -= required

		# Mark the building as upgraded
		UpgradeManager.upgrade_building(building)

		# Reload the upgrade list to reflect changes
		populate_upgrade_list()
