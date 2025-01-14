extends TransformBuilding

class_name Smelter

var has_coal: bool = false
var has_ore: bool = false

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	var BD = BuildData
	
	# Define input directions and expected item types
	inputs = {BD.directions[(rotation + 2) % 4]: ItemManager.ORE, BD.directions[(rotation + 3) % 4]: ItemManager.COAL}
	#inputs = {BD.directions[(rotation + 2) % 4], BD.directions[(rotation + 3) % 4]]
	
	type = BuildData.SMELTER_ID
	operation_intervals = [8, 4, 2]
	operation_interval = operation_intervals[UpgradeManager.get_building_level(type)]
	
# Check if the smelter can accept the given item from the input direction
func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	if inputs.has(input_direction):
		if item.type == ItemManager.COAL and !has_coal:
			return true
		elif item.type % 10 == ItemManager.ORE and !has_ore:
			return true
	return false

# Handle item input
func input_item():

	# Check the type of the stored item and mark it as accepted
	if stored_item.type == ItemManager.COAL:
		ItemManager.delete_item(stored_item)
		stored_item = null
		has_coal = true
	elif stored_item.type % 10 == ItemManager.ORE:
		output_type = stored_item.type
		ItemManager.delete_item(stored_item)
		stored_item = null
		has_ore = true
		
	stored_item = null
	# Attempt to start generating the output
	try_generating()

# Attempt to start the generation process
func try_generating():
	if has_ore and has_coal and !is_generating:
		is_generating = true
		tick_counter = 0
		has_ore = false
		has_coal = false

# Update logic for the smelter
func _process(delta: float) -> void:
	if is_generating:
		tick_counter += delta
		if tick_counter >= operation_interval:
			generate_output()

# Generate the smelted item
func generate_output():
	is_generating = false
	tick_counter = 0
	
	# Create the smelted item
	var smelted_item_type = ItemManager.get_smelted_item_type()
	var smelted_item = Item.new()
	smelted_item.type = smelted_item_type
	
	# Output the smelted item
	stored_item = smelted_item
	#output_item(smelted_item)

## Output the smelted item to the connected belt or building
#func output_item(item: Item):
	## Logic to send the item to the output direction
	#for output_dir in outputs.keys():
		#if can_send_item(item, output_dir):
			#send_item(item, output_dir)
			#return
